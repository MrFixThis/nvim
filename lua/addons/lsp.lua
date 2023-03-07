local set_keymap = require("utils").set_keymap

return {
  --Mason
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        width = 0.9,
        height = 0.9,
      },
    },
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          ensure_installed = {},
        },
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = {
          ensure_installed = {},
        },
      }
    },
  },

  --Lsp
  {
    "neovim/nvim-lspconfig",
    init = function()
      set_keymap({
        { "n", "gD", vim.lsp.buf.declaration, },
        { "n", "<leader>du", vim.lsp.buf.definition, },
        { "n", "<leader>re", vim.lsp.buf.references, },
        { "n", "<leader>vi", vim.lsp.buf.implementation, },
        { "n", "<leader>sh", vim.lsp.buf.signature_help, },
        { "n", "<leader>gt", vim.lsp.buf.type_definition, },
        { "n", "<leader>gw", vim.lsp.buf.document_symbol, },
        { "n", "<leader>gW", vim.lsp.buf.workspace_symbol, },
        --Actions mappings
        { "n", "<leader>ah", vim.lsp.buf.hover, },
        { "n", "<leader>ca", vim.lsp.buf.code_action, },
        { "n", "<leader>rn", vim.lsp.buf.rename, },
        -- Few language severs support these three
        { "n", "<leader>=", function() vim.lsp.buf.format({ async = true }) end, },
        { "n", "<leader>ai", vim.lsp.buf.incoming_calls, },
        { "n", "<leader>ao", vim.lsp.buf.outgoing_calls, },
        --Diagnostics mappings
        { "n", "<leader>ee", vim.diagnostic.open_float, },
        { "n", "<leader>gp", vim.diagnostic.goto_prev, },
        { "n", "<leader>gn", vim.diagnostic.goto_next, },
        --Custom
        { "n", "<leader>~", ":LspRestart<CR>", },
      })
    end,
    config = function()
      local items = {
        servers = {
          tsserver = {},
          taplo = {},
          yamlls = {},
          vimls = {},
          cssls = {},
          pylsp = {},

          --Lua
          lua_ls = {
            -- cmd = { lua_ls_binary },
            single_file_support = true,
            settings = {
              Lua = {
                workspace = {
                -- Make the server aware of Neovim runtime files
                  library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                   },
                 },
                diagnostics = {
                  globals = { "vim" },
                  unusedLocalExclude = { "_*" },
                },
                format = {
                  enable = false,
                  defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                    continuation_indent_size = "2",
                  },
                },
                completion = {
                  workspaceWord = true,
                  callSnippet = "Both",
                },
                semantic = { enable = false },
                telemetry = { enable = false },
               },
             },
           },

          --Go
          gopls = {
            cmd = { "gopls", "serve" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
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

          --Html
          html = { filetypes = { "html", "jsp" } },
        },
      }


    end
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },

  -- Rust tools
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      local rt = require("rust-tools")
      local exec = require("rust-tools.executors")

      rt.setup({
        server = {
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "self",
          },
          checkOnSave = {
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
          cargo = { allFeatures = true },
          procMacro = { enable = true },
          on_attach = function(_, bfnr)
            local opts = { buffer = bfnr }
            set_keymap({
              { "n", "<leader>cr", rt.runnables.runnables,  opts },
              { "n", "<leader>cd", rt.debuggables.debuggables,  opts },
              { "n", "<leader>ct", rt.open_cargo_toml.open_cargo_toml, opts },
              { "n", "<leader>cs", rt.standalone.start_standalone_client, opts },
              { "n", "<leader>cc", rt.workspace_refresh.reload_workspace, opts },
            })
          end,
        },
        dap = {
          adapter = {
            type = "executable",
            command = "lldb-vscode",
            name = "rt_lldb",
          },
        },
        tools = {
          executor = exec.toggleterm,
          inlay_hints = {
            auto = false,
          },
        },
      })
    end,
    dependencies = {
      {
        "saecki/crates.nvim",
        version = 'v0.3.0',
        config = true,
      },
    },
  },

  -- Null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local nls = require("null-ls")

      nls.setup({
        border = "rounded",
        debounce = 150,
        save_after_format = false,
        sources = {
          --- ...
        },
      })
    end,
  },

  -- Snippets
  {
    "hrsh7th/vim-vsnip",
    load = "InsertEnter",
    config = function()
      vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snippet/vsnip")
      local opts = { expr = true, silent = false }
      set_keymap({
        { "i", "<C-q>", "vsnip#expandable() ? \'<Plug>(vsnip-expand)\'    : \'<C-k>\'", opts },
        { "i", "<C-k>", "vsnip#jumpable(1)  ? \'<Plug>(vsnip-jump-next)\' : \'<Tab>\'", opts },
        { "i", "<C-j>", "vsnip#jumpable(-1) ? \'<Plug>(vsnip-jump-prev)\' : \'<S-Tab>\'", opts },
        { "s", "<C-q>", "vsnip#expandable() ? \'<Plug>(vsnip-expand)\'    : \'<C-k>\'", opts },
        { "s", "<C-k>", "vsnip#jumpable(1)  ? \'<Plug>(vsnip-jump-next)\' : \'<Tab>\'", opts },
        { "s", "<C-j>", "vsnip#jumpable(-1) ? \'<Plug>(vsnip-jump-prev)\' : \'<S-Tab>\'", opts },
      })
    end,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  }, -- TODO: Change to LuaSnip

  -- Cmp
  {
    "hrsh7th/nvim-cmp",
    load = "InsertEnter",
    config = function()
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      local cmp = require("cmp")
      local lk = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-f>"] = cmp.mapping.scroll_docs(-2),
          ["<C-d>"] = cmp.mapping.scroll_docs(2),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = false
          },
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "buffer", keyword_lenght = 5 },
          { name = "path" },
          { name = "vsnip" },
        }),
        formatting = {
          format = lk.cmp_format({
            with_text = true,
            menu = {
              buffer = "[Buff]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Api]",
              path = "[Path]",
              vsnip = "[Snip]",
            },
         }),
       },
       window = {
         completion = {
           border = "rounded",
         },
         documentation = {
           border = "rounded",
         },
       },
     })
   end,
   dependencies = {
     "hrsh7th/cmp-buffer",
     "hrsh7th/cmp-path",
     "hrsh7th/cmp-nvim-lsp",
     "hrsh7th/cmp-nvim-lua",
     "hrsh7th/cmp-vsnip",
     "onsails/lspkind-nvim",
   },
 },
}
