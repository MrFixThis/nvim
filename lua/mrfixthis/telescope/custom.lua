local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local M = {}

-- our picker function: colors
M.search_dotfiles = function ()
  local setts = themes.get_dropdown {
    prompt_title = "~ dotfiles ~",
    cwd = "~/.config/nvim/",
    hidden = false,
    previewer = false
  }
  builtin.find_files(setts)
end

return M
