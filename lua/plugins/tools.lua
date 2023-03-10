local set_keymap = require("utils").set_keymap
return {
  -- Plenary
  "nvim-lua/plenary.nvim",

  -- Nvim-tree
  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      { "<c-p>", "<CMD>NvimTreeToggle<CR>", silent = true },
    },
    opts = {
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
          quit_on_focus_loss = false,
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
    },
    config = function(_, opts)
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

      opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, opts)
      require("nvim-tree").setup(opts)
    end
  },

  -- Toggleterm
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {
      open_mapping = [[<A-t>]],
      shade_filetypes = {},
      shading_factor = 1,
      direction = "float",
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    },
    config = function(_, opts)
      local dark_orange = vim.api.nvim_get_color_by_name("DarkOrange")
      opts = vim.tbl_deep_extend("force",
        {
          opts,highlights = {
            FloatBorder = {
              guifg = dark_orange,
            },
          }
        }, opts)
      require("toggleterm").setup(opts)

      --Term spawner
      local spawn_term = function(cmd, dir)
        require("toggleterm.terminal").Terminal:new({
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
    end,
  },

  -- Crate versioning
  {
    "saecki/crates.nvim",
    ft = "toml",
    version = "v0.3.0",
    opts = {
      popup = {
        autofocus = true,
        show_version_date = true,
        max_height = 20,
        border = "rounded",
      },
    },
    keys = {
      {
        "<localleader>ct", function() require("crates").toggle() end,
        desc = "Crates: Toggle", silent = true,
      },
      {
        "<localleader>cf", function() require("crates").show_features_popup() end,
        desc = "Crates: Show features", silent = true,
      },
      {
        "<localleader>cv", function() require("crates").show_versions_popup() end,
        desc = "Crates: Show versions", silent = true,
      },
      {
        "<localleader>cd", function() require("crates").show_dependencies_popup() end,
        desc = "Crates: Show dependencies", silent = true,
      },
      {
        "<localleader>cH", function() require("crates").open_homepage() end,
        desc = "Crates: Go to homepage", silent = true,
      },
      {
        "<localleader>cR", function() require("crates").open_repository() end,
        desc = "Crates: Go to repository", silent = true,
      },
      {
        "<localleader>cD", function() require("crates").open_documentation() end,
        desc = "Crates: Go to documentation", silent = true,
      },
      {
        "<localleader>cC", function() require("crates").open_crates_io() end,
        desc = "Crates: Go to crates.io", silent = true,
      },
    },
  },

  -- Rest-nvim
  {
    "NTBBloodbath/rest.nvim",
    ft = "http",
    opts = {
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
    },
    config = function(_, opts)
      local rest_nvim = require("rest-nvim")
      rest_nvim.setup(opts)
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

  -- Colorizer
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        virtualtext = "■",
      },
    },
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
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
    event = "VeryLazy",
    config = function()
      local persistence = require("persistence")
      persistence.setup()
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
    end,
  },

  -- Leap
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap: forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap: backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap: from windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },

  --Todo-comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<localleader>tc", "<CMD>TodoTelescope<CR>",
        desc = "TODO Comments: All", silent = true
      },
    },
    opts = {
      gui_style = {
        fg = "NONE",
        bg = "NONE",
      },
      highlight = {
        keyword = "fg",
      },
    },
  },

  -- Trouble.nivm
  {
    "folke/trouble.nvim",
    keys = {
      {
        "<localleader>tt", "<CMD>TroubleToggle<CR>",
        desc = "Trouble: Toggle", silent = true
      },
    },
    opts = {
      position = "top",
    },
  },

  -- Ssr.nvim
  {
    "cshuaimin/ssr.nvim",
    keys = {
      { "<localleader>s",
        function() require("ssr").open() end,
        desc = "Structural replace",
        mode = { "n", "x" },
      },
    }
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
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      set_keymap({
        { "n", "<leader>u", "<CMD>UndotreeShow<CR>", { desc = "Undotree toggle" } }
      })
    end,
  },

  -- Maximizer
  {
    "szw/vim-maximizer",
    keys = {
      {
        "<leader>ma", "<CMD>MaximizerToggle!<CR>",
        desc = "Maximizer toggle", silent = true
      },
    },
  },
}
