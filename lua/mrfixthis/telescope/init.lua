local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true}
local telescope = require("telescope")

telescope.setup {
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.95,
      height = 0.85,
      prompt_position = "top",
    },
    pickers = {
      find_files = {
        theme = "ivy"
      }
    }
  },
}

keymap("n", "<leader>ps", [[:lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>]], opts)
keymap("n", "<C-p>", [[:lua require('telescope.builtin').git_files()<CR>]], opts)
keymap("n", "<leader>sg", [[:lua require('telescope.builtin').find_files()<CR>]], opts)
keymap("n", "<leader>pw", [[:lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>]], opts)
keymap("n", "<leader>bk", [[:lua require('telescope.builtin').buffers()<CR>]], opts)
keymap("n", "<leader>th", [[:lua require('telescope.builtin').help_tags()<CR>]], opts)
keymap("n", "<leader>gr", [[:lua require('telescope.builtin').live_grep()<CR>]], opts)
keymap("n", "<leader>te", [[:Telescope<CR>]], opts)
keymap("n", "<leader>do", [[:lua require("mrfixthis.telescope.custom").search_nvm_dotfiles()<CR>]], opts)
keymap("n", "<leader>dO", [[:lua require("mrfixthis.telescope.custom").search_dotfiles()<CR>]], opts)
