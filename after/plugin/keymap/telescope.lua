local set_keymap = require("mrfixthis.keymap").set_keymap
local telescope = require("telescope.builtin")
local tl_custom = require("mrfixthis.telescope.custom")

local telescope_maps = {
  {"n", "<leader>te", ":Telescope<CR>"},
  {"n", "<C-p>", function() telescope.git_files() end},
  {"n", "<leader>th", function() telescope.help_tags() end},
  {"n", "<leader>gs", function() telescope.find_files() end},
  {"n", "<leader>mk", function() telescope.buffers() end},
  {"n", "<leader>gr", function() telescope.live_grep() end},
  {"n", "<leader>pw",
    function() telescope.grep_string({search = vim.fn.expand("<cword>")}) end
  },
  {"n", "<leader>ps",
    function() telescope .grep_string({search = vim.fn.input("Grep For > ")}) end
  },
  --Custom telescope functions
  {"n", "<leader>do", function() tl_custom.search_nvm_dotfiles() end},
  {"n", "<leader>dO", function() tl_custom.search_dotfiles() end},
}

set_keymap(telescope_maps)
