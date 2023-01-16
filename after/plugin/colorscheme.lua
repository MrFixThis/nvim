local secure_require = require("mrfixthis.tools").general.secure_require
local report, mods = secure_require({
  "nebulous",
  "nebulous.functions",
})
if report then
  report(); return
end

--Nebulous setup
local scheme = mods.nebulous_functions.get_colors("fullmoon")
mods.nebulous.setup({
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
  },
}) --"I love your work, Yagua"
