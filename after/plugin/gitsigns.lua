local gitsigns = require("gitsigns")
local set_keymap = require("mrfixthis.keymap").set_keymap

--Gitsigns setup
gitsigns.setup({
  signs = {
    add          = {hl = "GitSignsAdd"   , text = "│", numhl="GitSignsAddNr"   , linehl="GitSignsAddLn"},
    change       = {hl = "GitSignsChange", text = "│", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn"},
    delete       = {hl = "GitSignsDelete", text = "_", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn"},
    topdelete    = {hl = "GitSignsDelete", text = "‾", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn"},
    changedelete = {hl = "GitSignsChange", text = "~", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn"},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  preview_config = {
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
  on_attach = function(bufnr)
    local opt = {expr = true, buffer = bufnr}
    local gitsigns_mappings = {
      -- Actions
      {{"n", "v"}, "<leader>hs", ":Gitsigns stage_hunk<CR>"},
      {{"n", "v"}, "<leader>hr", ":Gitsigns reset_hunk<CR>"},
      {"n", "<leader>hS", gitsigns.stage_buffer},
      {"n", "<leader>hu", gitsigns.undo_stage_hunk},
      {"n", "<leader>hR", gitsigns.reset_buffer},
      {"n", "<leader>hp", gitsigns.preview_hunk},
      {"n", "<leader>hb", function() gitsigns.blame_line{full = true} end},
      {"n", "<leader>tb", gitsigns.toggle_current_line_blame},
      {"n", "<leader>hd", gitsigns.diffthis},
      {"n", "<leader>hD", function() gitsigns.diffthis("~") end},
      {"n", "<leader>fd", gitsigns.toggle_deleted},
      -- Text object
      {{"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>"},
     -- Navigation
      {
        "n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(gitsigns.next_hunk)
          return "<Ignore>"
        end, opt
      },
      {
        "n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(gitsigns.prev_hunk)
          return "<Ignore>"
        end, opt
      },
    }
    set_keymap(gitsigns_mappings)
  end
})
