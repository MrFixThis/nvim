local set_keymap = require("utils").set_keymaps

return {
  -- Nvim-tree
  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      {"<c-p>", ":NvimTreeToggle<CR>"},
    },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
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
      filters = {
        dotfiles = true,
      },
      notify = {
        threshold = 5
      },
      view = {
        adaptive_size = true,
        width = 32,
        hide_root_folder = false,
        side = "right",
        number = true,
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
        mappings = {
          custom_only = false,
          list = {
            { key = "<CR>",    action = "edit" },
            { key = "t",       action = "edit" },
            { key = "<C-]>",   action = "cd" },
            { key = "<C-v>",   action = "vsplit" },
            { key = "<C-s>",   action = "split" },
            { key = "<C-t>",   action = "tabnew" },
            { key = "<",       action = "prev_sibling" },
            { key = ">",       action = "next_sibling" },
            { key = "<BS>",    action = "close_node" },
            { key = "h",       action = "close_node" },
            { key = "<Tab>",   action = "preview" },
            { key = "I",       action = "toggle_ignored" },
            { key = ".",       action = "toggle_dotfiles" },
            { key = "R",       action = "refresh" },
            { key = "a",       action = "create" },
            { key = "<S-D>",   action = "remove" },
            { key = "r",       action = "rename" },
            { key = "<C-r>",   action = "full_rename" },
            { key = "x",       action = "cut" },
            { key = "c",       action = "copy" },
            { key = "p",       action = "paste" },
            { key = "[c",      action = "prev_git_item" },
            { key = "]c",      action = "next_git_item" },
            { key = "T",       action = "expand_all" },
            { key = "H",       action = "collapse_all" },
            { key = "-",       action = "dir_up" },
            { key = "q",       action = "close" },
          },
        },
      },
    }
  },

  -- Toggleterm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
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
        {"n", "<localleader>gg", function() spawn_term("lazygit") end},
        {"n", "<localleader>gd", function() spawn_term("lazydocker") end},
      })
    end,
    opts = function()
      local scheme = require("nebulous.functions").get_colors("midnight")
      return {
        -- size can be a number or function which is passed the current terminal
        size = 20,
        open_mapping = [[<A-t>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
        persist_size = true,
        persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
        direction = "float",
        close_on_exit = true, -- close the terminal window when the process exits
        shell = vim.o.shell, -- change the default shell
        auto_scroll = true, -- automatically scroll to the bottom on terminal output
        highlights = {
          FloatBorder = {
            guifg = scheme.DarkOrange
          },
        },
        float_opts = {
          border = "curved",
          winblend = 0,
        },
        winbar = {
          enabled = false,
          name_formatter = function(term) --  term: Terminal
            return term.name
          end
        },
      }
    end,
  },

  -- Rest-nvim
  {
    "NTBBloodbath/rest.nvim",
    ft = "http",
    config = function()
      local rest_nvim = require("rest_nvim")

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

      local opts = { buffer = true }
      set_keymap({
        { "n", "<leader>rr", rest_nvim.run, opts },
        { "n", "<leader>rR", function() rest_nvim.run(true) end, opts },
        { "n", "<leader>rf", rest_nvim.last, opts },
      })
    end,
  },

  -- Markdown preview
  -- {
  --   "toppair/peek.nvim",
  --   build = "deno task --quiet build:fast",
  --   keys = {
  --     {
  --       "<leader>op",
  --       function()
  --         local peek = require("peek")
  --         if peek.is_open() then
  --           peek.close()
  --         else
  --           peek.open()
  --         end
  --       end,
  --       desc = "Peek (Markdown Preview)",
  --     },
  --   },
  --   opts = { theme = "light" },
  -- },

  -- Trouble.nivm
  {
    "folke/trouble.nvim",
    opts = {}, -- TODO: configure
  },

  -- Persistence.nvim
  {
    "folke/persistence.nvim",
    opts = {} -- TODO: configure
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    opt = {}, -- TODO: configure
  },

  -- Undo tree
  {
    "mbbill/undotree",
    config = true,
    keys = {
      {"<leader>u", ":UndotreeShow<CR>"},
    }
  },

  -- Maximizer
  {
    "szw/vim-maximizer",
    config = true,
    keys = {
      {"<leader>ma", ":MaximizerToggle!<CR>"},
    },
  },

  -- Yanky.nvim
  {
    "gbprod/yanky.nvim",
    config = function() end, -- TODO: configure
  },

  -- Plenary
  "nvim-lua/plenary.nvim",
}
