return {
  -- Icons
  "nvim-tree/nvim-web-devicons",

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
███╗░░░███╗██████╗░███████╗██╗██╗░░██╗████████╗██╗░░██╗██╗░██████╗
████╗░████║██╔══██╗██╔════╝██║╚██╗██╔╝╚══██╔══╝██║░░██║██║██╔════╝
██╔████╔██║██████╔╝█████╗░░██║░╚███╔╝░░░░██║░░░███████║██║╚█████╗░
██║╚██╔╝██║██╔══██╗██╔══╝░░██║░██╔██╗░░░░██║░░░██╔══██║██║░╚═══██╗
██║░╚═╝░██║██║░░██║██║░░░░░██║██╔╝╚██╗░░░██║░░░██║░░██║██║██████╔╝
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝╚═════╝░
]]

      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("n", " " .. " New file", "<CMD>ene <BAR>startinsert<CR>"),
        dashboard.button("r", " " .. " Recent files", "<CMD>Telescope oldfiles<CR>"),
        dashboard.button("f", " " .. " Find file", "<CMD>Telescope find_files<CR>"),
        dashboard.button("t", " " .. " Find text", "<CMD>Telescope live_grep<CR>"),
        dashboard.button("s", " " .. " Restore session", [[<CMD>lua require("persistence").load()<CR>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", "<CMD>Lazy<CR>"),
        dashboard.button("m", " " .. " Mason", "<CMD>Mason<CR>"),
        dashboard.button("c", " " .. " Config", "<CMD>e $MYVIMRC<CR>"),
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
      -- Close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("user", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      -- Measure the sturtup time (plugins load)
      vim.api.nvim_create_autocmd("user", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡Loaded " .. stats.count
            .. " plugins in " .. ms .. "ms"
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

  -- Vim-Illuminate
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 100,
      filetypes_denylist = {
        "NvimTree",
        "DiffviewFiles",
        "DiffviewFileHistory",
        "notify",
        "alpha",
        "lazy",
        "mason",
        "toggleterm",
      },
    },
    config = function(_, opts)
      local illuminate = require("illuminate")

      illuminate.configure(opts)
      local function map(key, dir, buffer)
        require("utils").set_keymap({
          { "n", key, function() illuminate["goto_" .. dir .. "_reference"](false) end,
            { desc = "Iluminate: " .. dir .. " reference", buffer = buffer }
          },
        })
      end

      -- to avoid override
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
  },

  -- Ident guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    init = function() vim.opt.listchars:append "trail:𝁢" end,
    opts = {
      char = "│",
      filetype_exclude = {
        "help", "alpha", "neo-tree", "Trouble", "lazy", "mason"
      },
      show_trailing_blankline_indent = false,
      end_of_line = false,
      show_current_context = false,
    },
  },

  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      -- To exclude indentscope where i dont want it to be
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },

  -- Lsp servers' status spiner
  {
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      text = {
        done = "✔ ",
        spinner = "bouncing_bar",
      },
    },
  },

  -- Drops
  {
    "folke/drop.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = {
      max = 15,
      interval = 200,
      screensaver = false,
    },
    config = function(_, opts)
      math.randomseed(os.time())
      opts.theme = ({ "stars", "snow", "leaves" })[math.random(1, 3)]
      require("drop").setup(opts)
    end
  },
}
