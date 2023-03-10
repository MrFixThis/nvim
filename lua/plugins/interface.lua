return {
  -- Icons
  "nvim-tree/nvim-web-devicons",

  -- Notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<localleader>ns", "<CMD>Telescope notify<CR>",
        desc = "Notify: Show notifications", silent = true
      },
      {
        "<localleader>na",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Notify: Delete all notifications", silent = true
      },
    },
    opts = {
      timeout = 3000,
      stages = "fade",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts)
      local notify = require("notify")
      vim.notify = notify
      notify.setup(opts)
    end,
  },

  -- Enhanced vim.ui
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        prompt_align = "center",
        relative = "editor",
      },
    },
  },

  -- Lsp servers' status spiner
  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    opts = {
      text = {
        done = "✔ ",
        spinner = "bouncing_bar",
      },
    },
  },
}
