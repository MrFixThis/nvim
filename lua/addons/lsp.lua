local set_keymap = require("utils").set_keymap
return {
  --Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
        width = 0.9,
        height = 0.9,
      },
      ensure_installed = {
        "rustfmt",
        "stylua",
        "flake8",
      },
    },
    config = function(_, opts)
      -- Helper to install tools via `ensure_installed` key
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local pack = mr.get_package(tool)
        if not pack:is_installed() then
          pack:install()
        end
      end
    end,
  },

  --Lsp
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
    },
    opts = {
      autoformat = true,
      diagnostics = {
        underline = true,
        severity_sort = true,
      },
      servers = {
        -- Lua
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              -- workspace = {
               --  library = {
               --    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
               --    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
               --   },
               -- },
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

        -- Go
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

        -- Html
        html = { filetypes = { "html", "jsp" } },
        -- Json
        jsonls = {},
      },
    },
    config = function(_, opts)
      require("utils").create_autocmd({
        lsp_attach = {
          autocmd = {
            {
              event = { "BufReadPre", "BufNewFile" },
              pattern = { "*", },
              callback = function(args)
                local bufnr = args.buf
                local buf = { buffer = bufnr }
                set_keymap({
                  { "n", "gD", vim.lsp.buf.declaration, buf },
                  { "n", "<leader>du", vim.lsp.buf.definition, buf },
                  { "n", "<leader>re", vim.lsp.buf.references, buf },
                  { "n", "<leader>vi", vim.lsp.buf.implementation, buf },
                  { "n", "<leader>sh", vim.lsp.buf.signature_help, buf },
                  { "n", "<leader>gt", vim.lsp.buf.type_definition, buf},
                  { "n", "<leader>gw", vim.lsp.buf.document_symbol, buf},
                  { "n", "<leader>gW", vim.lsp.buf.workspace_symbol, buf},
                  --Actions mappings
                  { "n", "<leader>ah", vim.lsp.buf.hover, buf },
                  { "n", "<leader>ca", vim.lsp.buf.code_action, buf },
                  { "n", "<leader>rn", vim.lsp.buf.rename, buf },
                  -- Few language severs support these three
                  { "n", "<leader>=", function() vim.lsp.buf.format({ async = true }) end, buf },
                  { "n", "<leader>ai", vim.lsp.buf.incoming_calls, buf },
                  { "n", "<leader>ao", vim.lsp.buf.outgoing_calls, buf },
                  --Diagnostics mappings
                  { "n", "<leader>ee", vim.diagnostic.open_float, buf },
                  { "n", "<leader>gp", vim.diagnostic.goto_prev, buf },
                  { "n", "<leader>gn", vim.diagnostic.goto_next, buf },
                  --Custom
                  { "n", "<leader>~", ":LspRestart<CR>", buf },
                })
              end,
            },
          },
          opts = { clear = true },
        }
      })

      -- Diagnostics
      local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      -- Floating preview window's borders
      local original_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = "rounded" -- to force the rounded in everything
        return original_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- Build of clients' capabilities
      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities())

      capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
      }

      -- Setup servers
      local setup_server = function(server)
        local server_opts = vim.tbl_deep_extend("force",
          { capabilities = vim.deepcopy(capabilities) }, servers[server] or {})
          require("lspconfig")[server].setup(server_opts)
      end

      require("mason-lspconfig").setup_handlers({ setup_server })
      require("neodev").setup()
    end,
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
          on_attach = function(_, bufnr)
            local opts = { buffer = bufnr }
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
  },

  -- Crate versioning
  {
    "saecki/crates.nvim",
    version = "v0.3.0",
    config = true,
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
}
