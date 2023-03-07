return {
  -- Comment
  {
    "numToStr/Comment.nvim",
    config = function()
      local comment = require("Comment")
      local ft = require("Comment.ft")

      --Custom comment placeholders
      ft.http = "# %s"
      ft.jsp =  "<%-- %s --%>"

      comment.setup({
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = false,
        ---Lines to be ignored while comment/uncomment.
        ignore = nil,
        ---LHS of toggle mappings in NORMAL + VISUAL mode
        ---@type table
        toggler = {
            ---line-comment keymap
            line = "gcc",
            ---block-comment keymap
            block = "ghc",
        },
        ---LHS of operator-pending mappings in NORMAL + VISUAL mode
        ---@type table
        opleader = {
            ---line-comment keymap
            line = "gc",
            ---block-comment keymap
            block = "gh",
        },
        ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
        mappings = {
            ---operator-pending mapping
            basic = true,
            ---extra mapping
            extra = true,
            ---extended mapping
            extended = false,
        },
        ---Pre-hook, called before commenting the line
        pre_hook = nil,
        ---Post-hook, called after commenting is done
        post_hook = nil,
      })
    end,
  },

  -- Formatter
  {
    "mhartington/formatter.nvim",
    opts = {
      logging = false,
      filetype = {
        javascript = {
          -- prettier
          function()
            return {
              exe = "prettier",
              args = {
                "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"
              },
              stdin = true
            }
          end
        },
      },
    },
  },

  -- Closetags
  {
    "alvan/vim-closetag",
    config = function()
      --Closetags settings
      --vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml, *.ts, *.tsx,*.jsx,*.js'
      vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml'
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

  -- Surround
  "tpope/vim-surround",
}
