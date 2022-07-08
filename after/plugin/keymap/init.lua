local remap = require('mrfixthis.keymap')
local nnoremap = remap.nnoremap
local vnoremap = remap.vnoremap
local tnoremap = remap.tnoremap
local opts = {silent = true}

--Windows and tabs navigation
nnoremap("<C-h>", ":wincmd h<CR>", opts)
nnoremap("<C-l>", ":wincmd l<CR>", opts)
nnoremap("<C-j>", ":wincmd j<CR>", opts)
nnoremap("<C-k>", ":wincmd k<CR>", opts)
nnoremap("<C-h>", ":wincmd h<CR>", opts)
nnoremap("<Right>", "gt")
nnoremap("<Left>", "gT")

--Buffer utils
nnoremap("<localleader>w", ":w<CR>")
nnoremap("<localleader>v", ":q<CR>")
nnoremap("<localleader>W", ":w!<CR>")
nnoremap("<localleader>V", ":q!<CR>")
nnoremap("<localleader>=", "<C-W>=")
  --Format
nnoremap("<leader>y", "\"+y")
vnoremap("<leader>y" ,"\"+y")
nnoremap("<leader>Y", "gg\"+yG")
nnoremap("<silent><leader>ws", ":%s/\\s\\+$//e<CR>")

--Split
nnoremap("<A-'>", "<C-W>5V")
nnoremap("<A-.>", "<C-W>5>") --TODO: make keymaps for open splits
nnoremap("<C-'>", "<C-W><")  --remap!
nnoremap("<C-.>", "<C-W>>")

--Terminal keymaps
tnoremap("<A-h>", "<C-\\><C-n><C-w>h")
tnoremap("<A-l>", "<C-\\><C-n><C-w>j")
tnoremap("<A-j>", "<C-\\><C-n><C-w>k")
tnoremap("<A-k>", "<C-\\><C-n><C-w>l")

--Plugin keymaps
nnoremap("<leader>u", ":UndotreeShow<CR>", opts)
nnoremap("<leader>ma", ":MaximizerToggle!<CR>", opts)
