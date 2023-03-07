local M = {}

--Configs builder
M.makeConfig = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument = {
    completion = {
      completionItem = {
        insertReplaceSupport = false,
      },
    },
    codeLens = {
      dynamicRegistration = false
    },
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
  }

  return {
    flags = {
      debounce_text_changes = 100,
    },
    handlers = {},
    capabilities = capabilities,
    init_options = {},
    settings = {},
  }
end


--Language servers setup
local lua_ls_root_path = string.format("%s/.local/servers/lua-language-server", home)
local lua_ls_binary = string.format("%s/bin/lua-language-server", lua_ls_root_path)
local lang_servers = {
  --Default config language servers
  cssls = true,
  yamlls = true,
  vimls = true,
  taplo = true,

  --Lua
  lua_ls = {
    cmd = {lua_ls_binary},
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
          },
        },
        semantic = {enable = false},
        telemetry = {
          enable = false
        },
      },
    },
  },

  --Go
  gopls = {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod", "gotmpl"},
    root_dir = mods.lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
    single_file_support = true,
    settings = {
      gopls = {
        gofumpt = true,
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

  --Html
  html = {filetypes = {"html", "jsp"}},
}

--Rust
mods.rust_tools.setup({
  server = {
    capabilities = default_config.capabilities,
    imports = {
      granularity = {
        group = "module",
      },
      prefix = "self",
    },
    cargo = {
      buildScripts = {
        enable = true,
      },
    },
    procMacro = {
      enable = true
    },
  },
  dap = {
    adapter = {
      type = "executable",
      command = "lldb-vscode",
      name = "rt_lldb",
    },
  },
  tools = {
    executor = mods.rust_tools_executors.toggleterm,
    inlay_hints = {
      auto = false,
    },
  },
})

for server, configs in pairs(lang_servers) do
  setup_server(server, configs)
end

return M
