local M = {}
local home = os.getenv("HOME")
local lsp = require("lspconfig")
local sumneko_root_path = string.format("%s/.local/servers/lua-language-server", home)
local sumneko_binary = string.format("%s/bin/lua-language-server", sumneko_root_path)

--Capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true --...
M.capabilities = require("cmp_nvim_lsp").update_capabilities(M.capabilities)

--Language server setter
local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end
  config = vim.tbl_deep_extend("force", {
    capabilities = M.capabilities,
  }, config)

  lsp[server].setup(config)
end

---Language servers setup
local lang_servers = {
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
          },
        },
      },
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
}

for server, configs in pairs(lang_servers) do
  setup_server(server, configs)
end

--Interface settings
require('mrfixthis.lsp.interface')
--Cmp configurations
require('mrfixthis.lsp.cmp')

return M
