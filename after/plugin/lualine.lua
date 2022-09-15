--format_uri sanitizes the java's package classes' names
local format_filename = function()
  local symbols = {modified = " [+]", readonly = " [-]", unnamed = "[No Name]"}
  local filename = vim.fn.expand("%:p")

  if vim.startswith(filename, "jdt://") then
    local package = filename:match("contents/[%a%d.-]+/([%a%d.-]+)") or ""
    local class = filename:match("contents/[%a%d.-]+/[%a%d.-]+/([%a%d$]+).class") or ""
    filename = string.format("%s::%s", package, class)
  else
    filename = vim.fn.expand('%:~:.')
  end

  if filename == "" then
    filename = symbols.unnamed
  end
  if vim.bo.modified then
    filename = filename .. symbols.modified
  end
  if vim.bo.modifiable == false or vim.bo.readonly == true then
    filename = filename .. symbols.readonly
  end

  return filename
end

--Lualine setup
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto", --To abstract the nebulous colors
    component_separators = {left = "", right = ""},
    section_separators = {left = "", right = ""},
    disabled_filetypes = {
      statusline = {},
      winbar = {
        "NvimTree",
        "NeogitStatus",
        "NeogitPopup",
        "DiffviewFiles",
        "DiffviewFileHistory",
      },
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 100,
      tabline = 50,
      winbar = 10,
    },
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff", "diagnostics"},
    lualine_c = {
      {
        format_filename,
        path = 1,
        shorting_target = 40,
        symbols = {
          modified = " [+]",
          readonly = " [-]",
          unnamed = "[No Name]",
        }
      }
    },
    lualine_x = {"encoding", "fileformat", "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"}
  },
  tabline = {
    lualine_a = {
      {
        "tabs",
        max_length = vim.o.columns / 1.6,
        mode = 1,
      }
    },
    lualine_z = {"require('dap').status()"},
  },
  inactive_winbar = {
    lualine_a = {
      {
        format_filename,
        path = 1,
        symbols = {
          modified = " [+]",
          readonly = " [-]",
          unnamed = "[No Name]",
        }
      }, "diagnostics"
    },
  },
  extensions = {
    "toggleterm",
    "nvim-dap-ui",
  }
})
