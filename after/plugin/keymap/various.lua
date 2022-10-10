local set_keymap = require("mrfixthis.keymap").set_keymap

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
}

set_keymap(various_mappings)
