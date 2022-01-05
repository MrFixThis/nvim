local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local M = {}

-- our picker function: colors
M.search_nvm_dotfiles = function ()
  local setts = themes.get_dropdown {
    prompt_title = "~ nvim dotfiles ~",
    cwd = "~/.dotfiles/nvim/.config/nvim/",
    hidden = false,
    previewer = false
  }
  builtin.find_files(setts)
end

 M.search_dotfiles = function()
  local setts = themes.get_dropdown {
    prompt_title = "~ config dotfiles ~",
    cwd = "~/.dotfiles/",
    hidden = true,
    previewer = false
  }
  builtin.find_files(setts)
end

return M
