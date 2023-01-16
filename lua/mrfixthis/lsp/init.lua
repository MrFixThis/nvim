local tools = require("mrfixthis.tools").general
local report, mods = tools.secure_require({
  "lspconfig",
  "cmp_nvim_lsp",
  "rust-tools",
})
if report then
  report(); return
end

--Cmp configurations
require("mrfixthis.lsp.cmp")
--Interface settings
require("mrfixthis.lsp.interface")

local M = {}
local home = os.getenv("HOME")

--Configs builder
M.makeConfig = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- completion config
  vim.tbl_deep_extend("force", capabilities, mods.cmp_nvim_lsp.default_capabilities())
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
  -- codeLens configs
  capabilities.textDocument.codeLens = { dynamicRegistration = false }

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

--Language server setter
local default_config = M.makeConfig()
local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then config = {} end
  config = vim.tbl_deep_extend("force", default_config, config)

  mods.lspconfig[server].setup(config)
end

--Lsp keymaps
tools.set_keymap({
  {"n", "gD", vim.lsp.buf.declaration},
  {"n", "<leader>du", vim.lsp.buf.definition},
  {"n", "<leader>re", vim.lsp.buf.references},
  {"n", "<leader>vi", vim.lsp.buf.implementation},
  {"n", "<leader>sh", vim.lsp.buf.signature_help},
  {"n", "<leader>gt", vim.lsp.buf.type_definition},
  {"n", "<leader>gw", vim.lsp.buf.document_symbol},
  {"n", "<leader>gW", vim.lsp.buf.workspace_symbol},

  --Actions mappings
  {"n", "<leader>ah", vim.lsp.buf.hover},
  {"n", "<leader>ca", vim.lsp.buf.code_action},
  {"n", "<leader>rn", vim.lsp.buf.rename},

  -- Few language severs support these three
  {"n", "<leader>=",  function() vim.lsp.buf.format({async = true}) end},
  {"n", "<leader>ai", vim.lsp.buf.incoming_calls},
  {"n", "<leader>ao", vim.lsp.buf.outgoing_calls},

  --Diagnostics mappings
  {"n", "<leader>ee", vim.diagnostic.open_float},
  {"n", "<leader>gp", vim.diagnostic.goto_prev},
  {"n", "<leader>gn", vim.diagnostic.goto_next},
})

--Language servers setup
local sumneko_root_path = string.format("%s/.local/servers/lua-language-server", home)
local sumneko_binary = string.format("%s/bin/lua-language-server", sumneko_root_path)
local lang_servers = {
  --Default config language servers
  cssls = true,
  yamlls = true,
  vimls = true,

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
    standalone = true,
  },
  dap = {
    adapter = {
      type = "executable",
      command = "lldb-vscode",
      name = "rt_lldb",
    },
  },
  tools = {
    inlay_hints = {
      auto = false,
    },
  },
})

for server, configs in pairs(lang_servers) do
  setup_server(server, configs)
end

return M
