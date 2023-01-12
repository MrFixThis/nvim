local dap = require("dap")
local symbols = {modified = " [+]", readonly = " [-]", unnamed = "[No Name]"}
local scape = function(fname) return fname:gsub("%%", "%%%%") end

-- format_filename sanitizes the java's packages contents names in the status bar
local format_filename = function()
  local fname = scape(vim.fn.expand("%:p"))

  if vim.startswith(fname, "jdt://") then
    local package = fname:match("contents/[%a%d.-]+/([%a%d.-]+)") or ""
    local class = fname:match("contents/[%a%d.-]+/[%a%d.-]+/([%a%d$]+).class") or ""
    fname = string.format("%s::%s", package, class)
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

-- dap_lsp_status_report retrieves either lsp or dap status messages
local sw = vim.startswith
local dap_lsp_status_report = function()
  local status = vim.lsp.util.get_progress_messages()
  local result = ""

  if dap.session() then
    result = dap.status()
  elseif not vim.tbl_isempty(status) then
    local percentage
    local content = {}

    for _, rep in pairs(status) do
      if rep.name == "jdtls" then
          if sw(rep.message, "Building") or
            (sw(rep.title, "Publish") or sw(rep.title, "Validate")) then
          return result
        end
      end

      if rep.message then
        table.insert(content, rep.title .. ": " .. rep.message)
      else
        table.insert(content, rep.title)
      end
      if rep.percentage then
        percentage = math.max(percentage or 0, rep.percentage)
      end
    end

    if percentage then
      result = string.format("(%d%%%%) %s", percentage, table.concat(content, ", "))
    else
      result = table.concat(content, ", ")
    end
  end
  return result
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
        "notify",
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
    -- lualine_c = {format_filename},
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
    lualine_z = {dap_lsp_status_report},
  },
  inactive_winbar = {
    lualine_a = {format_filename, "diagnostics"},
  },
  extensions = {
    "toggleterm",
    "nvim-dap-ui",
  }
})
