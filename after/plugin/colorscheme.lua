--Colorscheme Settings
local nebulous = require("nebulous")
local scheme = require("nebulous.functions").get_colors("fullmoon")

nebulous.setup {
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
    LineNr =       {fg = scheme.Blue,   bg = scheme.none, style = scheme.none},
    CursorLineNr = {fg = scheme.Yellow, bg = scheme.none, style = scheme.none},
  }
} --"I love your work, Yagua"
