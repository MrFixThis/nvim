-- Lsp UI configurations
  -- Diagnostics icons
local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

  -- Floating preview window's borders
local original_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = "rounded" -- to force the rounded in everything
  return original_util_open_floating_preview(contents, syntax, opts, ...)
end

return {
  -- Themes
  {
    "Yagua/nebulous.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      local scheme = require("nebulous.functions").get_colors("fullmoon")
      return {
        variant = "midnight",
        disable = {
          background = false,
          endOfBuffer = false,
        },
        italic = {
          comments   = true,
          keywords   = true,
          functions  = false,
          variables  = false,
        },
        custom_colors = {
          LineNr =       { fg = scheme.Blue,   bg = scheme.none, style = scheme.none },
          CursorLineNr = { fg = scheme.Yellow, bg = scheme.none, style = scheme.none },
        },
      }
    end,
  },
  "tokyonight.nvim",
  "eddyekofo94/gruvbox-flat.nvim",
  "gruvbox-community/gruvbox",

  -- Icons
  "ryanoasis/vim-devicons",
  "kyazdani42/nvim-web-devicons",

  -- Cosmetic
  {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {
      text = {
        done = "✔ ",
        spinner = "bouncing_bar",
      },
    },
  },
}
