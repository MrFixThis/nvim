require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto", --To abstract the nebulous colors
    component_separators = { left = "|", right = "|"},
    section_separators = { left = " ", right = " "},
    -- disabled_filetypes = {}, --Disable when x filetype is detected
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff", "diagnostics"},
    lualine_c = {
      {
        "filename",
        symbols = {
          modified = " [+]",
          readonly = " [-]",
          unnamed = "[No Name]",
        }
      }
    },
    lualine_x = {
      "require('dap').status()",
      "encoding", "fileformat", "filetype",
    },
    lualine_y = {"progress"},
    lualine_z = {"location"}
  },
})
