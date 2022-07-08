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
