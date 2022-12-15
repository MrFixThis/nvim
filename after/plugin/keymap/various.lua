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
  {"n", "<leader>go", ":DiffviewOpen<CR>"},
  {"n", "<leader>gh", ":DiffviewFileHistory<CR>"},
  {"n", "<leader>gq", ":DiffviewClose<CR>"},
  --Sessions
  {"n", "<leader>ss", tools.save_session},
  {"n", "<leader>ls", tools.load_session},
}

set_keymap(various_mappings)
