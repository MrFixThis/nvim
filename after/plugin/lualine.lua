local secure_require = require("mrfixthis.tools").general.secure_require
local report, mods = secure_require({"lualine", "dap"})
if report then
  report(); return
end

local symbols = {
  modified = " [+]", readonly = " [-]", unnamed = "[No Name]", newfile = "[New File] "
}
local scape = function(fname) return fname:gsub("%%", "%%%%") end
local is_new_file = function()
  local filename = vim.fn.expand("%")
  return filename ~= "" and vim.bo.buftype == "" and
    vim.fn.filereadable(filename) == 0
end

-- format_filename
local format_filename = function()
  local fname = scape(vim.fn.expand("%:p"))

  -- Sanitizes and formats the java's packages contents names
  if vim.startswith(fname, "jdt://") then
    local package = fname:match("contents/[%a%d.-]+/([%a%d.-]+)") or ""
    local class = fname:match("contents/[%a%d.-]+/[%a%d.-]+/([%a%d$]+).class") or ""
    fname = string.format("%s::%s", package, class)

  -- Cuts and formats the path to the Rust's builtin files
  elseif fname:match(".rustup/toolchains") then
    local package = fname:match("library/(.+)/.+")
    local file = fname:match(".+/(.+)$")
    fname = string.format("rust::%s/%s", package, file)
  else
      fname = vim.fn.expand("%:~:.")
  end

  if fname ~= "" then
    if is_new_file() then fname = symbols.newfile .. fname end
    if vim.bo.modified then fname = fname .. symbols.modified end
    if vim.bo.modifiable == false or vim.bo.readonly == true then
      fname = fname .. symbols.readonly
    end
  else
   fname = symbols.unnamed
  end
  return fname
end

-- format_tab_label sanitizes the java's packages contents names in the tabs
local format_tab_label = function(fname)
  if vim.startswith(fname, "%") then
    local package = fname:match("[%l.?]+") or ""
    local class = fname:match("([%a.-*$]+).class") or ""
    fname = string.format("%s::%s", package, class)
  end
  return fname
end

-- lualine setup
mods.lualine.setup({
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
        "notify",
      },
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 10,
      tabline = 10,
      winbar = 1,
    },
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff", "diagnostics"},
    lualine_c = {format_filename},
    lualine_x = {"encoding", "fileformat", "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"},
  },
  tabline = {
    lualine_a = {
      {
        "tabs",
        max_length = vim.o.columns / 2,
        mode = 1,
        fmt = format_tab_label,
      }
    },
    lualine_z = {mods.dap.status},
  },
  inactive_winbar = {
    lualine_a = {format_filename, "diagnostics"},
  },
  extensions = {
    "toggleterm",
    "nvim-dap-ui",
  }
})
