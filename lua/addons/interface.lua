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
  -- Icons
  "ryanoasis/vim-devicons",
  "kyazdani42/nvim-web-devicons",

  -- Cosmetic
  {
    "j-hui/fidget.nvim",
    opts = {
      text = {
        done = "✔ ",
        spinner = "bouncing_bar",
      },
    },
  },
}
