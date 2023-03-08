local set_keymap = require("utils").set_keymap
return {
  -- Plenary
  "nvim-lua/plenary.nvim",

  -- Nvim-tree
  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      { "<c-p>", "<CMD>NvimTreeToggle<CR>" },
    },
    opts = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        -- Custom maps
        set_keymap({
          { "n", "t", api.node.open.edit, opts("Open") },
        })
      end

      return {
        on_attach = on_attach,
        update_cwd = true,
        renderer = {
          indent_markers = {
            enable = true,
          },
        },
        actions = {
          file_popup = {
            open_win_config = {
             border = "rounded",
             zindex = 200,
            },
          },
          open_file = {
            quit_on_open = true,
          },
        },
        filters = { dotfiles = true, },
        notify = { threshold = 5 },
        view = {
          adaptive_size = true,
          width = 32,
          side = "right",
          relativenumber = true,
          signcolumn = "no",
          float = {
            enable = true,
            open_win_config = {
              relative = "editor",
              border = "rounded",
              width = 32,
              height = 29,
              row = 2,
              col = 0xF423F, -- -1
            },
          },
        },
      }
    end
  },

  -- Toggleterm
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    version = "*",
    opts = function()
      local scheme = require("nebulous.functions").get_colors("midnight")
      local T = require("toggleterm.terminal")

      --Term spawner
      local spawn_term = function(cmd, dir)
        T.Terminal:new({
          cmd = cmd,
          dir = dir or vim.fn.expand("%:p:h"),
          direction = "float",
          start_in_insert = true,
          close_on_exit = true,
        }):toggle()
      end

      -- Toggleterm keymaps
      set_keymap({
        {
          "n", "<localleader>gg",
          function() spawn_term("lazygit") end,
          { desc = "Toggle Lazygit" }
        },
        {
          "n", "<localleader>gd",
          function() spawn_term("lazydocker") end,
          { desc = "Toggle Lazydocker" }
        },
      })

      return {
        open_mapping = [[<A-t>]],
        shade_filetypes = {},
        shading_factor = 1,
        direction = "float",
        highlights = {
          FloatBorder = {
            guifg = scheme.DarkOrange
          },
        },
        float_opts = {
          border = "curved",
          winblend = 0,
        },
      }
    end,
  },

  -- Rest-nvim
  {
    "NTBBloodbath/rest.nvim",
    ft = "http",
    config = function()
      local rest_nvim = require("rest-nvim")

      rest_nvim.setup({
        result_split_horizontal = false,
        result_split_in_place = "left",
        skip_ssl_verification = false,
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          show_url = true,
          show_http_info = true,
          show_headers = true,
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end
          },
        },
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })

      set_keymap({
        {
          "n", "<leader>rr",
          rest_nvim.run,
          { buffer = true, desc = "Rest.nvim run" }
        },
        {
          "n", "<leader>rR",
          function() rest_nvim.run(true) end,
          { buffer = true, desc = "Rest.nvim re-run" }
        },
        {
          "n", "<leader>rf",
          rest_nvim.last,
          { buffer = true, desc = "Rest.nvim run last" }
        },
      })
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    lazy = false,
    config = function()
      local hpm = require("harpoon.mark")
      local hpui = require("harpoon.ui")

      set_keymap({
        { "n", "<leader>hm", hpui.toggle_quick_menu, { desc = "Telescope: Harpoon marks" } },
        { "n", "<leader>ha", hpm.add_file, { desc = "Harpoon: Add file" } },
        { "n", "<leader>hn", hpui.nav_prev, { desc = "Harpoon: Previous file" } },
        { "n", "<leader>hp", hpui.nav_next, { desc = "Harpoon: Next file" } },
      })
    end,
  },

  -- Persistence.nvim
  {
    "folke/persistence.nvim",
    lazy = false,
    config = function()
      local persistence = require("persistence")

      set_keymap({
        -- restore the session for the current directory
        {
          "n", "<localleader>ls",
          persistence.load,
          { desc = "Persistence: Restore current dir session" },
        },
        {
          "n", "<localleader>ll",
          function() persistence.load({ last = true }) end,
          { desc = "Persistence: Restore last session" },
        },
        {
          "n", "<localleader>ld",
          persistence.stop,
          { desc = "Persistence: Stop persistence" },
        },
      })

      persistence.setup()
    end,
  },

  -- Trouble.nivm
  {
    "folke/trouble.nvim",
    keys = {
        { "<localleader>tt", "<CMD>TroubleToggle<CR>", desc = "Trouble: Toggle" },
    },
    opts = {
      position = "top",
      signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
      },
    },
  },

  -- Yanky.nvim
  {
    "gbprod/yanky.nvim",
    enabled = false,
    event = "BufReadPost",
    config = function() end, -- TODO: Config Yanky
  },

  -- Undo tree
  {
    "mbbill/undotree",
    config = true,
    keys = {
      { "<leader>u", "<CMD>UndotreeShow<CR>", desc = "Undotree toggle" },
    }
  },

  -- Maximizer
  {
    "szw/vim-maximizer",
    config = true,
    keys = {
      { "<leader>ma", "<CMD>MaximizerToggle!<CR>", desc = "Maximizer toggle" },
    },
  },
}
