local neogit = require("neogit")
local diffview = require("diffview")

--Neogit setup
neogit.setup({
  integrations = {
    diffview = true,
  },
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
