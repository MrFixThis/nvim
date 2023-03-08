local tools = require("mrfixthis.tools")

--General keymaps
local general = {
  --Windows and tabs navigation
  {"n", "<C-h>", ":wincmd h<CR>"},
  {"n", "<C-l>", ":wincmd l<CR>"},
  {"n", "<C-j>", ":wincmd j<CR>"},
  {"n", "<C-k>", ":wincmd k<CR>"},
  {"n", "<C-h>", ":wincmd h<CR>"},
  {"n", "<Right>", "gt"},
  {"n", "<Left>", "gT"},
    --Split
  {"n", "<A-.>", "<C-W>5>"},
  {"n", "<A-,>", "<C-W>5<"},
  {"n", "<A-'>", "<C-W>+"},
  {"n", "<A-;>", "<C-W>-"},
  {"n", "<localLeader>=", "<C-W>="},

  --Buffer utils
  {"n", "<localleader>w", ":w<CR>"},
  {"n", "<localleader>v", ":q<CR>"},
  {"n", "<localleader>W", ":w!<CR>"},
  {"n", "<localleader>V", ":q!<CR>"},
  {"n", "<localleader>=", "<C-W>="},
    --Format
  {"n", "<leader>y", "\"+y"},
  {"v", "<leader>y" ,"\"+y"},
  {"n", "<leader>Y", "\"+yg$"},
  {"v", "<leader>Y", "\"+yg$"},
  {"n", "<leader>yg", "gg\"+yG"},
  {"x", "<leader>p", "\"_dP"},
  {"n", "<leader>ws", ":%s/\\s\\+$//e<CR>"},

  --Terminal keymaps
  {"t", "<A-Esc>", "<C-\\><C-N>"},
  {"t", "<A-h>", "<C-\\><C-n><C-w>h"},
  {"t", "<A-l>", "<C-\\><C-n><C-w>j"},
  {"t", "<A-j>", "<C-\\><C-n><C-w>k"},
  {"t", "<A-k>", "<C-\\><C-n><C-w>l"},
}

--Various keymaps
local various = {
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
  {"n", "<leader>ss", tools.session.save_session},
  {"n", "<leader>ls", tools.session.load_session},
}

tools.general.set_keymap(general)
tools.general.set_keymap(various)
