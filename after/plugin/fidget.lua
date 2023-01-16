local secure_require = require("mrfixthis.tools").general.secure_require
local report, fidget = secure_require("fidget")
if report then
  report(); return
end

fidget.setup({
  text = {
    done = "✔ ",
    spinner = "bouncing_bar",
  },
})
