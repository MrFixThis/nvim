local neogit = require("neogit")
local diffview = require("diffview")

--Neogit setup
neogit.setup({
  disable_hint = true,
  disable_insert_on_commit = false,
  disable_commit_confirmation = true,
  signs = {
    section = {">", "v"},
    item = {">", "v"},
    hunk = {"", ""},
  },
  integrations = {
    diffview = true,
  },
  mappings = {
    status = {
      ["q"] = function()
        vim.api.nvim_buf_delete(0, {})
        vim.api.nvim_cmd({cmd = "lc!"}, {})
      end,
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
