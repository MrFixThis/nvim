local set_keymap = require("mrfixthis.keymap").set_keymap
local rest_nvim = require("rest-nvim")
local opt = {buffer = true}

local http_mappings = {
  --Rest_nvim
  {"n", "<leader>rr", rest_nvim.run, opt},
  {"n", "<leader>rR", function() rest_nvim.run(true) end, opt},
  {"n", "<leader>rf", rest_nvim.last, opt},
}

set_keymap(http_mappings)
