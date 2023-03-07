return {
  {
    "Yagua/nebulous.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local nebulous = require("nebulous")
      local scheme = require("nebulous.functions").get_colors("fullmoon")

      nebulous.setup({
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
        custom_colors = {
          LineNr =       { fg = scheme.Blue,   bg = scheme.none, style = scheme.none },
          CursorLineNr = { fg = scheme.Yellow, bg = scheme.none, style = scheme.none },
        },
      })
    end,
  },

  "folke/tokyonight.nvim",
  "eddyekofo94/gruvbox-flat.nvim",
  "gruvbox-community/gruvbox",
}
