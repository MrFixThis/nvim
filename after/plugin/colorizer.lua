local secure_require = require("mrfixthis.tools").general.secure_require
local report, colorizer = secure_require("colorizer")
if report then
  report(); return
end

--Colorizer setup
colorizer.setup(
  {"*"},
  {
    RGB      = true,     -- #RGB hex codes
    RRGGBB   = true,     -- #RRGGBB hex codes
    RRGGBBAA = true,     -- #RRGGBBAA hex codes
    rgb_fn   = true,     -- CSS rgb() and rgba() functions
    hsl_fn   = true,     -- CSS hsl() and hsla() functions
    css      = true,     -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn   = true,     -- Enable all CSS *functions*: rgb_fn, hsl_fn
  }
)
