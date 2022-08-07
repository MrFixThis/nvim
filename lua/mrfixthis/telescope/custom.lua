local M = {}
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")

--Nvim config files
M.search_nvim_conffiles = function ()
  local set_pick = themes.get_dropdown({
    prompt_title = "< Nvim dotfiles >",
    cwd = "~/.dotfiles/nvim/.config/nvim/",
    hidden = false,
    previewer = false,
  })
  builtin.find_files(set_pick)
end

--.dotfiles
M.search_dotfiles = function()
  local set_pick = themes.get_dropdown {
    prompt_title = "< Config dotfiles >",
    cwd = "~/.dotfiles/",
    hidden = true,
    previewer = false
  }
  builtin.find_files(set_pick)
end

return M
