local secure_require = require("mrfixthis.tools").general.secure_require
local report, mods = secure_require({"lualine", "dap"})
if report then
  report(); return
end

-- State symbols
local symbols = {modified = " [+]", readonly = " [-]", unnamed = "[No Name]"}
-- helper functions
local scape = function(fname) return fname:gsub("%%", "%%%%") end

-- format_filename formats the files names
local format_filename = function()
  local fname = scape(vim.fn.expand("%:p"))
  local filetype = vim.fn.expand("%:e")
  local cargo_home = os.getenv("CARGO_HOME")
  local rustup_home = os.getenv("RUSTUP_HOME")

  -- Sanitizes and formats the java's packages contents names
  if vim.startswith(fname, "jdt://") then
    local package = fname:match("contents/[%a%d.-]+/([%a%d.-]+)") or ""
    local class = fname:match("contents/[%a%d.-]+/[%a%d.-]+/([%a%d$]+).class") or ""
    fname = string.format("%s::%s", package, class)

  -- Cuts and formats the path to the Rust's builtin files and Cargo's registry
  -- files
  elseif vim.startswith(filetype, "rs")
    and fname:match(string.format("%s%s", cargo_home, "/.+"))
    or fname:match(string.format("%s%s", rustup_home, "/.+")) then

    local package = fname:match("library/(.+)/.+") or fname:match(".+/(.+)/.+$")
    local file = fname:match(".+/(.+)$")
    fname = string.format("rust::%s/%s", package, file)
  else
      fname = vim.fn.expand("%:~:.")
  end

  if fname ~= "" then
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

-- nick_or_dap_status shows either my nick name or dap's status
local nick_or_dap_status = function()
  if mods.dap.session() then return mods.dap.status() end
  return "MrFixThis"
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
        max_length = vim.o.columns / 1.8,
        mode = 1,
        fmt = format_tab_label,
      }
    },
    lualine_z = {nick_or_dap_status},
  },
  inactive_winbar = {
    lualine_a = {format_filename, "diagnostics"},
  },
  extensions = {
    "toggleterm",
    "nvim-dap-ui",
  }
})
