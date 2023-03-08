local set_keymap = require("utils").set_keymap
return {
  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>go", "<CMD>Gitsigns<CR>" },
    },
    opts = {
      signs = {
        add          = { hl = "GitSignsAdd"   , text = "│", numhl="GitSignsAddNr"   , linehl="GitSignsAddLn" },
        change       = { hl = "GitSignsChange", text = "│", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn" },
        delete       = { hl = "GitSignsDelete", text = "_", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn" },
        topdelete    = { hl = "GitSignsDelete", text = "‾", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn" },
        changedelete = { hl = "GitSignsChange", text = "~", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn" },
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
        local gitsigns = package.loaded.gitsigns
        local opts = { expr = true, buffer = bufnr }
        set_keymap({
          -- Actions
          { {"n", "v"}, "<leader>hs", "<CMD>Gitsigns stage_hunk<CR>" },
          { {"n", "v"}, "<leader>hr", "<CMD>Gitsigns reset_hunk<CR>" },
          { "n", "<leader>hS", gitsigns.stage_buffer },
          { "n", "<leader>hu", gitsigns.undo_stage_hunk },
          { "n", "<leader>hR", gitsigns.reset_buffer },
          { "n", "<leader>hp", gitsigns.preview_hunk },
          { "n", "<leader>hb", function() gitsigns.blame_line{full = true } end },
          { "n", "<leader>tb", gitsigns.toggle_current_line_blame },
          { "n", "<leader>hd", gitsigns.diffthis },
          { "n", "<leader>hD", function() gitsigns.diffthis("~") end },
          { "n", "<leader>fd", gitsigns.toggle_deleted },
          -- Text object
          { {"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>" },
         -- Navigation
          {
            "n", "]c", function()
              if vim.wo.diff then return "]c" end
              vim.schedule(gitsigns.next_hunk)
              return "<Ignore>"
            end, opts
          },
          {
            "n", "[c", function()
              if vim.wo.diff then return "[c" end
              vim.schedule(gitsigns.prev_hunk)
              return "<Ignore>"
            end, opts
          },
        })
      end
    }
  },

  -- Diffview
  {
    "sindrets/diffview.nvim",
    config = true,
    keys = {
      {
        "<leader>gg", "<CMD>DiffviewOpen<CR>",
        desc = "Diffview: Open"
      },
      {
        "<leader>gh", "<CMD>DiffviewFileHistory<CR>",
        desc = "Diffview: Open history"
      },
      {
        "<leader>gq", "<CMD>DiffviewClose<CR>",
        desc = "Diffview: Close"
      },
    }
  },

  -- Git-worktree
  {
    "ThePrimeagen/git-worktree.nvim", -- TODO: Configure Git-worktree
    enabled = false,
    opts = {}
  },
}
