return {
  -- LuaSnip
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = {
      {
        "<TAB>",
        function()
          return require("luasnip").jumpable(1) and "<PLUG>luasnip-jump-next" or "<TAB>"
        end,
        expr = true, silent = true, mode = "i",
      },
      {
        "<TAB>", function() require("luasnip").jump(1) end, silent = true, mode = "s"
      },
      {
        "<S-TAB>", function() require("luasnip").jump(-1) end,
        silent = true, mode = { "i", "s" }
      },
    },
  },

  -- Cmp
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
    },
    opts = function()
      local cmp = require("cmp")
      local lk = require("lspkind")
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
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
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
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
     }
   end,
 },

  -- Mini.comment
  {
    "echasnovski/mini.comment",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    event = "VeryLazy",
    opts = {
      hooks = {
        pre = function()
            require("ts_context_commentstring.internal").update_commentstring({})
        end,
      }
    },
    config = function(_, opts) require("mini.comment").setup(opts) end
  },

  -- Mini.surround
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "za", -- Add surrounding in Normal and Visual modes
        delete = "zd", -- Delete surrounding
        find = "zf", -- Find surrounding (to the right)
        find_left = "zF", -- Find surrounding (to the left)
        highlight = "zh", -- Highlight surrounding
        replace = "zr", -- Replace surrounding
        update_n_lines = "zn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
    config = function(_, opts) require("mini.surround").setup(opts) end
  },

  -- Mini.pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function()
      require("mini.pairs").setup()
    end,
  }
}
