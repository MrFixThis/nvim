return {
  -- Icons
  "nvim-tree/nvim-web-devicons",

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
███╗░░░███╗██████╗░███████╗██╗██╗░░██╗████████╗██╗░░██╗██╗░██████╗
████╗░████║██╔══██╗██╔════╝██║╚██╗██╔╝╚══██╔══╝██║░░██║██║██╔════╝
██╔████╔██║██████╔╝█████╗░░██║░╚███╔╝░░░░██║░░░███████║██║╚█████╗░
██║╚██╔╝██║██╔══██╗██╔══╝░░██║░██╔██╗░░░░██║░░░██╔══██║██║░╚═══██╗
██║░╚═╝░██║██║░░██║██║░░░░░██║██╔╝╚██╗░░░██║░░░██║░░██║██║██████╔╝
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝╚═════╝░
]]

      dashboard.section.header.val = vim.split(logo, "\n")
      --
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<CMD>Telescope find_files<CR>"),
        dashboard.button("n", " " .. " New file", "<CMD>ene <BAR>startinsert<CR>"),
        dashboard.button("r", " " .. " Recent files", "<CMD>Telescope oldfiles<CR>"),
        dashboard.button("g", " " .. " Find text", "<CMD>Telescope live_grep<CR>"),
        dashboard.button("c", " " .. " Config", "<CMD>e $MYVIMRC<CR>"),
        dashboard.button("s", " " .. " Restore session", [[<CMD>lua require("persistence").load()<CR>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", "<CMD>Lazy<CR>"),
        dashboard.button("m", " " .. " Mason", "<CMD>Mason<CR>"),
        dashboard.button("q", " " .. " Quit", "<CMD>qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end
      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

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
