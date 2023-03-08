-- Lsp UI configurations
  --diagnostics icons
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

  --Todo-comments
  {
    "folke/todo-comments.nvim",
    keys = {
        { "<localleader>tc", "<CMD>TodoTelescope<CR>", desc = "TODO Comments: All" },
    },
    opts = {
      gui_style = {
        fg = "NONE",
        bg = "NONE",
      },
      highlight = {
        keyword = "fg",
      },
    },
  },

  -- Cosmetic
  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    opts = {
      text = {
        done = "✔ ",
        spinner = "bouncing_bar",
      },
    },
  },
}
