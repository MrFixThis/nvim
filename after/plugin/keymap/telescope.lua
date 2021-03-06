local set_keymap = require("mrfixthis.keymap").set_keymap
local telescope = require("telescope.builtin")
local tl_custom = require("mrfixthis.telescope.custom")

--Telescope keymaps
local telescope_maps = {
  {"n", "<leader>tt", ":Telescope<CR>"},
  {"n", "<leader>mw", telescope.buffers},
  {"n", "<leader>mk", telescope.git_files},
  {"n", "<leader>th", telescope.help_tags},
  {"n", "<leader>gs", telescope.find_files},
  {"n", "<C-n>", telescope.diagnostics},
  {"n", "<leader>gr", telescope.live_grep},
  {"n", "<leader>pw",
    function() telescope.grep_string({search = vim.fn.expand("<cword>")}) end
  },
  {"n", "<leader>ps",
    function() telescope.grep_string({search = vim.fn.input("Grep For > ")}) end
  },
  --Custom telescope functions
  {"n", "<leader>do", tl_custom.search_nvim_conffiles},
  {"n", "<leader>dO", tl_custom.search_dotfiles},
}

set_keymap(telescope_maps)
