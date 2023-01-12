local set_keymap = require("mrfixthis.keymap").set_keymap
local tools = require("mrfixthis.tools")

--Single keymaps
local various_mappings = {
  --Nvim tree
  {"n", "<c-p>", ":NvimTreeToggle<CR>"},
  --Formatter
  {"n", "<leader>fo", ":Format<CR>"},
  --Undotree
  {"n", "<leader>u", ":UndotreeShow<CR>"},
  --Maximizer
  {"n", "<leader>ma", ":MaximizerToggle!<CR>"},
  --DiffView
  {"n", "<leader>gg", ":DiffviewOpen<CR>"},
  {"n", "<leader>gh", ":DiffviewFileHistory<CR>"},
  {"n", "<leader>gq", ":DiffviewClose<CR>"},
  --Gitsigns
  {"n", "<leader>go", ":Gitsigns<CR>"},
  --Sessions
  {"n", "<leader>ss", tools.Session.save_session},
  {"n", "<leader>ls", tools.Session.load_session},
}

set_keymap(various_mappings)
