local tools = require("mrfixthis.tools").general
local report, rest_nvim = tools.secure_require("rest_nvim")
if report then
  report(); return
end

local opt = {buffer = true}
tools.set_keymap({
  --Rest_nvim
  {"n", "<leader>rr", rest_nvim.run, opt},
  {"n", "<leader>rR", function() rest_nvim.run(true) end, opt},
  {"n", "<leader>rf", rest_nvim.last, opt},
})
