local set_keymap = require("mrfixthis.keymap").set_keymap

--Single keymaps
local single_plug_mapings = {
  --Nvim tree
  {"n", "<c-p>", ":NvimTreeToggle<CR>"},
  --Formatter
  {"n", "<leader>fo", ":Format<CR>"},
  --Undotree
  {"n", "<leader>u", ":UndotreeShow<CR>"},
  --Maximizer
  {"n", "<leader>ma", ":MaximizerToggle!<CR>"},
  --Neogit
  {"n", "<leader>gg", ":Neogit<CR>"},
    --DiffView
  {"n", "<leader>go", ":DiffviewOpen<CR>"},
  {"n", "<leader>gh", ":DiffviewFileHistory<CR>"},
  {"n", "<leader>gd", ":DiffviewClose<CR>"},
}

set_keymap(single_plug_mapings)
