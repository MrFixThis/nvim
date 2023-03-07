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

return {
  --Mason
  {
    "williamboman/mason.nvim", -- TODO: configure
    opts = {
      "rustfmt", --...
    },
  },

  --Lsp
  {
    "neovim/nvim-lspconfig",
    opt = function()
      local default_config = M.makeConfig()
      local setup_server = function(server, config)
        if not config then
          return
        end

        if type(config) ~= "table" then config = {} end
        config = vim.tbl_deep_extend("force", default_config, config)

        mods.lspconfig[server].setup(config)
      end

    end,
  },

  "nvim-lua/plenary.nvim",
  "mfussenegger/nvim-jdtls",
    -- Snippets
  "rafamadriz/friendly-snippets",
  "hrsh7th/vim-vsnip",
    --Completion
  {
    "hrsh7th/nvim-cmp",
    load = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-vsnip",
      "onsails/lspkind-nvim",
    },
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
          {name = "nvim_lsp"},
          {name = "nvim_lua"},
          {name = "buffer", keyword_lenght = 5},
          {name = "path"},
          {name = "vsnip"},
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
  },

  -- Null-ls
  {
    "jose-elias-alvarez/null-ls.nvim", -- TODO: cofigure
    config = function() end,
  },

  --Lang tools
    --Go
  "ray-x/go.nvim",
    --Rust
  "simrat39/rust-tools.nvim",
}
