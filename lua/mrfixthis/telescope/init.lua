local telescope = require("telescope")
local telescope_actions = require("telescope.actions")

telescope.setup {
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.95,
      height = 0.85,
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    pickers = {
      find_files = {
        theme = "ivy"
      }
    },
    mappings = {
      i = {
        ["<C-z>"] = function(prompt_bufnr)
          telescope_actions.delete_buffer(prompt_bufnr)
        end,
      }
    }
  },
}
