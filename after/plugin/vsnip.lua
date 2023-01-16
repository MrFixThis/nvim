local set_keymap = require("mrfixthis.tools").general.set_keymap
--Vsnip setup
vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snippet/vsnip")
local opt = {expr = true, silent = false, noremap = false}
set_keymap({
  {"i", "<C-q>", "vsnip#expandable() ? \'<Plug>(vsnip-expand)\'    : \'<C-k>\'", opt},
  {"i", "<C-k>", "vsnip#jumpable(1)  ? \'<Plug>(vsnip-jump-next)\' : \'<Tab>\'", opt},
  {"i", "<C-j>", "vsnip#jumpable(-1) ? \'<Plug>(vsnip-jump-prev)\' : \'<S-Tab>\'", opt},
  {"s", "<C-q>", "vsnip#expandable() ? \'<Plug>(vsnip-expand)\'    : \'<C-k>\'", opt},
  {"s", "<C-k>", "vsnip#jumpable(1)  ? \'<Plug>(vsnip-jump-next)\' : \'<Tab>\'", opt},
  {"s", "<C-j>", "vsnip#jumpable(-1) ? \'<Plug>(vsnip-jump-prev)\' : \'<S-Tab>\'", opt},
})
