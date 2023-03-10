return {
  {
    "Yagua/nebulous.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "midnight",
      disable = {
        background = false,
        endOfBuffer = false,
      },
      italic = {
        comments   = true,
        keywords   = true,
        functions  = false,
        variables  = false,
      },
    },
    config = function(_, opts)
      local scheme = require("nebulous.functions").get_colors("fullmoon")
      opts = vim.tbl_deep_extend("force",
        {
          custom_colors = {
            LineNr =       { fg = scheme.Blue,   bg = scheme.none, style = scheme.none },
            CursorLineNr = { fg = scheme.Yellow, bg = scheme.none, style = scheme.none },
          }
        }, opts)
      require("nebulous").setup(opts)
    end,
  },
  {
    "folke/tokyonight.nvim",
    -- lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
      lualine_bold = true,
      on_highlights = function(hl, c)
        hl.CursorLineNr = { fg = c.orange }
        hl.LineNr = { fg = c.orange  }
        hl.LineNrAbove = { fg = c.fg_dark }
        hl.LineNrBelow = { fg = c.fg_dark }
      end,
    },
    config = function(_, opts)
      require("tokyonight").load(opts)
    end
  },

  "eddyekofo94/gruvbox-flat.nvim",
  "gruvbox-community/gruvbox",
}
