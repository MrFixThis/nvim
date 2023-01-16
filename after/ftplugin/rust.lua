local set_keymap = require("mrfixthis.tools").general.set_keymap
--Rust-tools mappings
local opt = {buffer = true}
set_keymap({
  -- Debbugging
  {"n", "<leader>co", ":RustDebuggables<CR>", opt},
})
