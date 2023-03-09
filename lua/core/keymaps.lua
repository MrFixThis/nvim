require("utils").set_keymap({
  -- Windows and tabs navigation
  { "n", "<C-h>", ":wincmd h<CR>" },
  { "n", "<C-l>", ":wincmd l<CR>" },
  { "n", "<C-j>", ":wincmd j<CR>" },
  { "n", "<C-k>", ":wincmd k<CR>" },
  { "n", "<C-h>", ":wincmd h<CR>" },
  { "n", "<Right>", "gt" },
  { "n", "<Left>", "gT" },
    -- Split
  { "n", "<A-.>", "<C-W>5>" },
  { "n", "<A-,>", "<C-W>5<" },
  { "n", "<A-'>", "<C-W>+" },
  { "n", "<A-;>", "<C-W>-" },
  { "n", "<localLeader>=", "<C-W>=" },

  -- Buffer utils
  { "n", "<localleader>w", ":w<CR>" },
  { "n", "<localleader>v", ":q<CR>" },
  { "n", "<localleader>W", ":w!<CR>" },
  { "n", "<localleader>V", ":q!<CR>" },
  { "n", "<localleader>=", "<C-W>=" },

    -- Format
  { "n", "<leader>y", "\"+y" },
  { "v", "<leader>y" ,"\"+y" },
  { "n", "<leader>Y", "\"+yg$" },
  { "v", "<leader>Y", "\"+yg$" },
  { "n", "<leader>yg", "gg\"+yG" },
  { "x", "<leader>p", "\"_dP" },
  { "n", "<leader>ws", ":%s/\\s\\+$//e<CR>" },

  -- Terminal keymaps
  { "t", "<A-Esc>", "<C-\\><C-N>" },
  { "t", "<A-h>", "<C-\\><C-n><C-w>h" },
  { "t", "<A-l>", "<C-\\><C-n><C-w>j" },
  { "t", "<A-j>", "<C-\\><C-n><C-w>k" },
  { "t", "<A-k>", "<C-\\><C-n><C-w>l" },
})
