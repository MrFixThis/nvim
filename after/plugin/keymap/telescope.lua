local remap = require("mrfixthis.keymap")
local nnoremap = remap.nnoremap
local telescope = require("telescope.builtin")

local key_maps = {
  {"<leader>te", ":Telescope<CR>"},
  {"<C-p>", function() telescope.git_files() end},
  {"<leader>th", function() telescope.help_tags() end},
  {"<leader>gs", function() telescope.find_files() end},
  {"<leader>mk", function() telescope.buffers() end},
  {"<leader>gr", function() telescope.live_grep() end},
  {
    "<leader>pw",
    function() telescope.grep_string({search = vim.fn.expand("<cword>")}) end
  },
  {
    "<leader>ps",
    function() telescope .grep_string({search = vim.fn.input("Grep For > ")}) end
  },
  {
    "<leader>do", function() require("mrfixthis.telescope.custom")
      .search_nvm_dotfiles() end
  },
  {
    "<leader>dO", function() require("mrfixthis.telescope.custom")
      .search_dotfiles() end
  },
}

for _, keymap in ipairs(key_maps) do
  local lhs, rhs, opts = unpack(keymap)
  nnoremap(lhs, rhs, opts)
end
