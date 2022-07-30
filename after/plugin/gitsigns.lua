--Gitsigns setup
require("gitsigns").setup({
  signs = {
    add =          {hl = "GitSignsAdd",    text = "│", numhl = "GitSignsAddNr"},
    change =       {hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr"},
    delete =       {hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr"},
    topdelete =    {hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr"},
    changedelete = {hl = "GitSignsDelete", text = "~", numhl = "GitSignsChangeNr"},
    keymaps = {
      noremap = true,
      ["n ]c"] = {expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
      ["n [c"] = {expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},
      ["n <leader>fs"] = "<cmd>lua require'gitsigns'.stage_hunk()<CR>",
      ["v <leader>fs"] = "<cmd>lua require'gitsigns'.stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>",
      ["n <leader>fu"] = "<cmd>lua require'gitsigns'.undo_stage_hunk()<CR>",
      ["n <leader>fr"] = "<cmd>lua require'gitsigns'.reset_hunk()<CR>",
      ["v <leader>fr"] = "<cmd>lua require'gitsigns'.reset_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>",
      ["n <leader>fR"] = "<cmd>lua require'gitsigns'.reset_buffer()<CR>",
      ["n <leader>fp"] = "<cmd>lua require'gitsigns'.preview_hunk()<CR>",
      ["n <leader>fb"] = "<cmd>lua require'gitsigns'.blame_line(true)<CR>",
      ["n <leader>fS"] = "<cmd>lua require'gitsigns'.stage_buffer()<CR>",
      ["n <leader>fU"] = "<cmd>lua require'gitsigns'.reset_buffer_index()<CR>",
      ["o ih"] = ":<C-U>lua require'gitsigns'.select_hunk()<CR>",
      ["x ih"] = ":<C-U>lua require'gitsigns'.select_hunk()<CR>",
    },
  },
})
