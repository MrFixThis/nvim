local has_rt, rt = pcall(require, "rust-tools")
if not has_rt then
  return
end

local set_keymap = require("mrfixthis.keymap").set_keymap
local opt = {buffer = true}

local rt_mappings = {
  -- Debbugging
  {"n", "<leader>co", rt.debuggables.debuggables, opt},
}

set_keymap(rt_mappings)
