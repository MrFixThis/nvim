local neogit = require("neogit")
local diffview = require("diffview")

--Neogit setup
neogit.setup({
  disable_hint = true,
  disable_commit_confirmation = true,
  integrations = {
    diffview = true,
  },
  mappings = {
    status = {
      ["h"] = "HelpPopup",
    }
  }
})

--DiffView setup
diffview.setup({
  file_panel = {
    listing_style = "tree",
    win_config = {
      position = "bottom",
      height = 14,
    },
  },
  file_history_panel = {
    win_config = {
      position = "bottom",
      height = 14,
    },
  },
})
