local lsp = require("lspconfig")
local jdtls = require("jdtls")
local M = {}
local HOME = os.getenv("HOME")

local sumneko_root_path = string.format("%s/.local/servers/lua-language-server", HOME)
local sumneko_binary = string.format("%s/bin/lua-language-server", sumneko_root_path)

--Capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

---Language servers setup
--Jdtls
M.setup_jdtls = function()
  -- Root dir config
  local root_markers = {
    "gradlew",
    "mvnw",
    ".git",
    --"pom.xml",
    --"build.gradle"
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

  --Lombok support
  local lombok_path = HOME .. "/.local/dev_tools/java/bundles/lombok/lombok.jar"
  if vim.fn.filereadable(lombok_path) > 0 then
    table.insert(config.cmd, 2, string.format("-javaagent:%s", lombok_path))
  end

  config.on_attach = function()
    jdtls.setup_dap({hotcodereplace = "auto"})
    jdtls.setup.add_commands()
    require("jdtls.dap").setup_dap_main_class_configs() --temporary
  end
  config.capabilities = capabilities

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
end --TODO: Improve this language server setting

--Other language servers
local servers = {
  --Default config language servers
  html = true,
  cssls = true,
  yamlls = true,
  vimls = true,
  rust_analyzer = true,

  --Lua
  sumneko_lua = {
    cmd = {sumneko_binary},
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";")
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {"vim"}
        },
        workspace = {
        -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
          }
        }
      }
    },
  },

  --Go
  gopls = {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod", "gotmpl"},
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

  --Js/Ts
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

  --Python
  pylsp = {
    plugins = {
      pyls_mypy = {
        enabled = true,
        live_mode = false,
      },
    },
  },
}

--Language server setup
local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  lsp[server].setup(config)
end

for server, configs in pairs(servers) do
  setup_server(server, configs)
end

return M
