local lsp = require('lspconfig')
local jdtls = require("jdtls")
local M = {}
local HOME = os.getenv('HOME')

--Capabilities
local custom_capabilities = vim.lsp.protocol.make_client_capabilities()
custom_capabilities.textDocument.completion.completionItem.snippetSupport = true
custom_capabilities = require("cmp_nvim_lsp").update_capabilities(custom_capabilities)

--keymaps
local key_maps = {
  {"n", "gD", "<cmd>lua vim.lsp.buf.declaration()"},
  {"n", "<leader>du", "<cmd>lua vim.lsp.buf.definition()"},
  {"n", "<leader>re", "<cmd>lua vim.lsp.buf.references()"},
  {"n", "<leader>vi", "<cmd>lua vim.lsp.buf.implementation()"},
  {"n", "<leader>sh", "<cmd>lua vim.lsp.buf.signature_help()"},
  {"n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()"},
  {"n", "<leader>gw", "<cmd>lua vim.lsp.buf.document_symbol()"},
  {"n", "<leader>gW", "<cmd>lua vim.lsp.buf.workspace_symbol()"},
  -- ACTION mappings
  {"n", "<leader>ah", "<cmd>lua vim.lsp.buf.hover()"},
  {"n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()"},
  {"n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()"},
  -- Few language severs support these three
  {"n", "<leader>=",  "<cmd>lua vim.lsp.buf.formatting()"},
  {"n", "<leader>ai", "<cmd>lua vim.lsp.buf.incoming_calls()"},
  {"n", "<leader>ao", "<cmd>lua vim.lsp.buf.outgoing_calls()"},
  -- Diagnostics mapping
  {"n", "<leader>ee", "<cmd>lua vim.diagnostic.open_float()"},
  {"n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()"},
  {"n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()"},
  --custom functions
  {"n", "<leader>ne", "<cmd>lua require('mrfixthis.lsp.util').diagnostics_qfixlist()"},
}

--keymaps setting
local set_keymaps = function(key_map)
  local km_opt = {noremap = true, silent = true}
  for _, maps in pairs(key_map) do
    local mode, lhs, rhs = unpack(maps)
    vim.api.nvim_buf_set_keymap(0, mode, lhs,
      string.format("%s<CR>", rhs), km_opt);
  end
end

--on attach
local custom_attach = function(_)
  set_keymaps(key_maps)
end

--Language servers
--# Java
--custom jdtls_on_attach
local function jdtls_on_attach(_)
  jdtls.setup_dap({hotcodereplace = 'auto'})
  jdtls.setup.add_commands()
  require('jdtls.dap').setup_dap_main_class_configs() --temporary

  local jdtls_keymaps = {
    {"n", "<leader>or", "<Cmd>lua require('jdtls').organize_imports()"},
    {"n", "<leader>av", "<Cmd>lua require('jdtls').test_class()"},
    {"n", "<leader>tm", "<Cmd>lua require('jdtls').test_nearest_method()"},
    {"v", "<leader>am", "<Esc><Cmd>lua require('jdtls').extract_variable(true)"},
    {"n", "<leader>am", "<Cmd>lua require('jdtls').extract_variable()"},
    {"n", "<leader>om", "<Cmd>lua require('jdtls').extract_constant()"},
    {"v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)"},
  }

  local extended_keymaps = vim.fn.extend(key_maps, jdtls_keymaps)
  set_keymaps(extended_keymaps)
end

--setup jdtls
M.setup_jdtls = function()
  -- Root dir config
  local root_markers = {
    "gradlew",
    "mvnw",
    ".git",
    --'pom.xml',
    --'build.gradle'
  }
  local root_dir = jdtls.setup.find_root(root_markers)
  local workspace_folder = string.format(
    "%s/.local/share/eclipse/%s", HOME, vim.fn.fnamemodify(root_dir, ":p:h:t")
  )
  -- Jdtls configs
  local config = {}

  config.settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/opt/jdks/jdk1.8.0_202/",
          },
          {
            name = "JavaSE-11",
            path = "/opt/jdks/jdk-11.0.12/",
          },
          {
            name = "JavaSE-14",
            path = "/opt/jdks/jdk-14.0.2/"
          },
        }
      }
    }
  }

  -- CMD
  config.cmd = {
    "/opt/jdks/jdk-14.0.2/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "-jar", vim.fn.glob(HOME .. "/.local/servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", HOME .. "/.local/servers/jdtls/config_linux",
    "-data", workspace_folder,
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  }

  --lombok support
  local lombok_path = HOME .. "/.local/dev_tools/java/bundles/lombok/lombok.jar"
  if vim.fn.filereadable(lombok_path) > 0 then
    table.insert(config.cmd, 2, string.format("-javaagent:%s", lombok_path))
  end

  config.on_attach = jdtls_on_attach
  config.capabilities = custom_capabilities

  local bundles = {
    vim.fn.glob(HOME .. "/.local/dev_tools/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
  }
  vim.list_extend(bundles, vim.split(vim.fn.glob(HOME .. "/.local/dev_tools/vscode-java-test/server/*.jar"), "\n"))

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  config.init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities;
  }

  --Setup client
  jdtls.start_or_attach(config)
end

local sumneko_root_path = string.format('%s/.local/servers/lua-language-server', HOME)
local sumneko_binary = string.format("%s/bin/lua-language-server", sumneko_root_path)

local servers = {
  --# Various
  html = true,
  cssls = true,
  yamlls = true,
  vimls = true,
  rust_analyzer = true,
  --# Lua
  sumneko_lua = {
    cmd = { sumneko_binary },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = vim.split(package.path, ';')
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'}
        },
        workspace = {
        -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
          }
        }
      }
    },
  },
  --# Js/Ts
  tsserver = {
    cmd = {"typescript-language-server", "--stdio"},
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx"
    },
  },
  --# Python
  pylsp = {
    plugins = {
      pyls_mypy = {
        enabled = true,
        live_mode = false,
      },
    },
  },
  --# Go
  gopls = {
    cmd = { "gopls", "serve" },
    filetypes = { "go", "gomod", "gotmpl" },
    root_dir = lsp.util.root_pattern("go.work", "go.mod", ".git"),
    single_file_support = true,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  },
}

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_attach = custom_attach,
    capabilities = custom_capabilities,
  }, config)

  lsp[server].setup(config)
end

for server, configs in pairs(servers) do
  setup_server(server, configs)
end

return M
