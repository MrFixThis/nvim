local symbols = {modified = " [+]", readonly = " [-]", unnamed = "[No Name]"}
--format_filename sanitizes the java's packages contents names in the status bar
local format_filename = function()
  local scape = function(fname) return fname:gsub("%%", "%%%%") end
  local fname = scape(vim.fn.expand("%:p"))

  if vim.startswith(fname, "jdt://") then
    local package = fname:match("contents/[%a%d.-]+/([%a%d.-]+)") or ""
    local class = fname:match("contents/[%a%d.-]+/[%a%d.-]+/([%a%d$]+).class") or ""
    fname = string.format("%s::%s", package, class)
  else
      fname = vim.fn.expand("%:~:.")
  end

  if fname == "" then fname = symbols.unnamed end
  if vim.bo.modified then fname = fname .. symbols.modified end
  if vim.bo.modifiable == false or vim.bo.readonly == true then
    fname = fname .. symbols.readonly
  end

  return fname
end

--format_tab_label sanitizes the java's packages contents names in the tabs
local format_tab_label = function(fname)
  if vim.startswith(fname, "%") then
    local package = fname:match("[%l.?]+") or ""
    local class = fname:match("([%a.-*$]+).class") or ""
    fname = string.format("%s::%s", package, class)
  end

  return fname
end

--Lualine setup
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto", --To abstract the nebulous' colors
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
      statusline = 10,
      tabline = 10,
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
    lualine_z = {"location"},
  },
  tabline = {
    lualine_a = {
      {
        "tabs",
        max_length = vim.o.columns / 1.6,
        mode = 1,
        fmt = format_tab_label,
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
