return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.95,
          height = 0.85,
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        pickers = {
          find_files = {
            theme = "ivy"
          },
        },
        mappings = {
          i = {
            ["<C-z>"] = function(prompt_bufnr)
              actions.delete_buffer(prompt_bufnr)
            end,
          },
        },
      },
      extensions = {
        ["ui-select"] = themes.get_dropdown({ hidden = true, }),
      },
    })

    -- Custom pickers
      --Nvim config files
    local search_nvim_conffiles = function ()
      local set_pick = themes.get_dropdown({
        prompt_title = "< Nvim config-files >",
        cwd = "~/.dotfiles/nvim/.config/nvim/",
        hidden = false,
        previewer = false,
        file_ignore_patterns = { "%.git" },
      })
      builtin.find_files(set_pick)
    end

      --.dotfiles
    local search_dotfiles = function()
      local set_pick = themes.get_dropdown({
        prompt_title = "< Dotfiles >",
        cwd = "~/.dotfiles/",
        hidden = true,
        previewer = false,
        file_ignore_patterns = { "nvim", "%.git" },
      })
      builtin.find_files(set_pick)
    end

    --Telescope keymaps
    require("utils").set_keymap({
      { "n", "<leader>tt", "<CMD>Telescope<CR>", { desc = "Telescope: Builtin" }, },
      { "n", "<leader>mw", builtin.buffers, { desc = "Telescope: Buffers" }, },
      { "n", "<leader>mk", builtin.git_files, { desc = "Telescope: Git files" }, },
      { "n", "<leader>th", builtin.help_tags, { desc = "Telescope: Help tags" }, },
      { "n", "<leader>gs", builtin.find_files, { desc = "Telescope: Find files" }, },
      { "n", "<C-n>", builtin.diagnostics, { desc = "Telescope: Diagnostics" }, },
      { "n", "<leader>gr", builtin.live_grep, { desc = "Telescope: Live grep" }, },
      { "n", "<leader>re", builtin.lsp_references, { desc = "Telescope: Lsp references" }, },
      {
        "n", "<leader>pw",
        function() builtin.grep_string({ search = vim.fn.expand("<cword>") }) end,
        { desc = "Telescope: Grep for word under cursor" },
      },
      {
        "n", "<leader>ps",
        function() builtin.grep_string({ search = vim.fn.input("Grep For > ") }) end,
        { desc = "Telescope: Grep for word" },
      },
      -- Custom telescope functions
      { "n", "<leader>do", search_nvim_conffiles, { desc = "Telescope: Search Nvim config files" }, },
      { "n", "<leader>dO", search_dotfiles, { desc = "Telescope: Search dotfiles" }, },
    })

    --Extensions loading
    telescope.load_extension("ui-select")
  end,
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-telescope/telescope-fzy-native.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
}
