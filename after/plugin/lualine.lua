--Lualine setup
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto", --To abstract the nebulous colors
    component_separators = {left = "|", right = "|"},
    section_separators = {left = "", right = ""},
    -- disabled_filetypes = {
    --   statusline = {},
    --   winbar = {},
    -- },
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 100,
    },
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff", "diagnostics"},
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = " [+]",
          readonly = " [-]",
          unnamed = "[No Name]",
        }
      }
    },
    lualine_x = {"encoding", "fileformat", "filetype",},
    lualine_y = {"progress"},
    lualine_z = {"location"}
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        max_length = vim.o.columns / 2,
        mode = 1,
      }
    },
    lualine_z = {"require('dap').status()",},
  },
})
