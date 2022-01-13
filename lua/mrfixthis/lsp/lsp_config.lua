local lsp = require('lspconfig')
local jdtls = require("jdtls")
local M = {}
local HOME = os.getenv('HOME')

--diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with (
  vim.lsp.diagnostic.on_publish_diagnostics, {
     underline = true,
     virtual_text = true,
     signs = true,
     update_in_insert = false,
     --virtual_text = {
       ----spacing = 4,
       ----prefix = '',
     --},
    }
)

--capabilities
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
}

--set keymaps
local set_keymaps = function(key_maps)
  local km_ops = {noremap = true, silent = true}
  for _, maps in pairs(key_maps) do
    local mode, keys, command = unpack(maps)
    vim.api.nvim_buf_set_keymap(0, mode, keys,
      string.format("%s<CR>", command), km_ops);
  end
end

--on attach
local on_attach = function(_)
  set_keymaps(key_maps)
end

local custom_code_action = function(items, prompt, label_fn, cb)
  local finders = require'telescope.finders'
  local actions = require'telescope.actions'
  local pickers = require'telescope.pickers'
  local themes = require("telescope.themes")
  local action_state = require'telescope.actions.state'
  local conf = require("telescope.config").values

  local opts = themes.get_cursor{}
  pickers.new(opts, {
    prompt_title = prompt,
    finder = finders.new_table {
      results = items,
      entry_maker = function (entry)
        return {
          value = entry,
          display = label_fn(entry),
          ordinal = label_fn(entry)
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function (prompt_bufnr)
      actions.select_default:replace(function ()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry(prompt_bufnr)
        cb(selection.value)
      end)
      return true
    end
  }):find()
end

--# Java
--custom jdtls_on_attach
local function jdtls_on_attach(_)
  jdtls.setup_dap({hotcodereplace = 'auto'})
  jdtls.setup.add_commands()
  require('jdtls.dap').setup_dap_main_class_configs() --temporary

  --UI
  require('jdtls.ui').pick_one_async = custom_code_action

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
          -- {
          --   name = "JavaSE-17",
          --   path = "/opt/jdks/jdk-17.0.1/"
          -- },
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
  vim.list_extend(bundles, vim.split(vim.fn.glob(HOME .. "/.local/dev_tools/java/vscode-java-test/server/*.jar"), "\n"))

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  config.init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities;
  }

  --Setup client
  jdtls.start_or_attach(config)
end

--# Lua
local sumneko_root_path = string.format('%s/.local/servers/lua-language-server', HOME)
local sumneko_binary = string.format("%s/bin/lua-language-server", sumneko_root_path)
lsp.sumneko_lua.setup{
  cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
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
  on_attach = on_attach,
  capabilities = custom_capabilities
}
--# Js/Ts
lsp.tsserver.setup {
  cmd = {"typescript-language-server", "--stdio"},
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx"
    },
  on_attach = on_attach,
  capabilities = custom_capabilities,
}

--# Python
lsp.pylsp.setup {
  plugins = {
    pyls_mypy = {
      enabled = true,
      live_mode = false,
    },
  },
  on_attach = on_attach,
  capabilities = custom_capabilities,
}
--# Vim
lsp.vimls.setup {
  on_attach = on_attach,
  capabilities = custom_capabilities,
}
--# C++/C
lsp.clangd.setup {
  on_attach = on_attach,
  capabilities = custom_capabilities,
}
--# HTML
lsp.html.setup {
  on_attach = on_attach,
  capabilities = custom_capabilities,
}
--# Css
lsp.cssls.setup {
  on_attach = on_attach,
  capabilities = custom_capabilities,
}
--# Go
lsp.gopls.setup {
  cmd = { "gopls", "serve" },
  filetypes = { "go", "gomod" },
  on_attach = on_attach,
  capabilities = custom_capabilities,
}

--# Rust
lsp.rust_analyzer.setup {
    cmd = { "rustup", "run", "nightly", "rust-analyzer"},
    on_attach = on_attach,
    capabilities = custom_capabilities,
    --[[
    settings = {
        rust = {
            unstable_features = true,
            build_on_save = false,
            all_features = true,
        },
    } --rust-analyzer options
    --]]
}

--TEMPORARY / Latex
-- lsp.texlab.setup {
--   cmd = { string.format("%s/.local/servers/texlab/texlab", HOME) },
--   filetypes = { "tex", "bib" },
--   on_attach = on_attach,
--   capabilities = custom_capabilities,
-- }

--# PHP
--lsp.intelephense.setup{
  --cmd = { "intelephense", "--stdio" },
  --filetypes = { "php" },
  --on_attach = on_attach,
--}
--# JSON
--lsp.jsonls.setup{ on_attach = on_attach }
--# DOCKER
--lsp.dockerls.setup{
  --on_attach = on_attach,
--}
----# YAML
--lsp.yamlls.setup{ on_attach = on_attach }
--lsp.sqlls.setup{
  --cmd = {"sql-language-server", "up", "--method", "stdio"},
  --on_attach = on_attach,
  --capabilities = custom_capabilities,
--}

return M
