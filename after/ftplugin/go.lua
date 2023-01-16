local set_keymap = require("mrfixthis.tools").general.set_keymap
-- go.nvim mappings
local opt = {buffer = true}
set_keymap({
  --General
  {"n", "<localleader>c", ":GoCmt<CR>", opt},
  {"n", "<localleader>t", ":GoAddTag<CR>", opt},
  {"n", "<localleader>T", ":GoRmTag<CR>", opt},
  {"n", "<localleader>r", ":GoIfErr<CR>", opt},
  {"n", "<localleader>s", ":GoFillStruct<CR>", opt},
  {"n", "<localleader>l", ":GoFillSwitch<CR>", opt},
  {"n", "<localleader>f", ":GoFixPlurals<CR>", opt},
  {"n", "<localleader>g", ":GoImpl ", opt},

  --Tools
  {"n", "<CR>k", ":GoRun<CR>", opt},
  {"n", "<CR>j", ":GoStop ", opt},
  {"n", "<CR>b", ":GoImport<CR>", opt},
  {"n", "<CR>l", ":GoLint<CR>", opt},
  {"n", "<CR>v", ":GoVet ", opt},
  {"n", "<CR>t", ":GoModTidy<CR>", opt},
  {"n", "<CR>m", ":GoModVendor<CR>", opt},
  {"n", "<CR>a", ":GoAlt<CR>", opt},
  {"n", "<CR>g", ":GoMockGen<CR>", opt},
})
