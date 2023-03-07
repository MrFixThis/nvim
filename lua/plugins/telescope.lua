return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")

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
        { "n", "<leader>tt", ":Telescope<CR>"  },
        { "n", "<leader>mw", builtin.buffers  },
        { "n", "<leader>mk", builtin.git_files },
        { "n", "<leader>th", builtin.help_tags },
        { "n", "<leader>gs", builtin.find_files },
        { "n", "<C-n>", builtin.diagnostics },
        { "n", "<leader>gr", builtin.live_grep },
        { "n", "<leader>re", builtin.lsp_references },
        { "n", "<leader>pw",
          function() builtin.grep_string({ search = vim.fn.expand("<cword>") }) end
        },
        {"n", "<leader>ps",
          function() builtin.grep_string({ search = vim.fn.input("Grep For > ") }) end
        },
        --Custom telescope functions
        { "n", "<leader>do", search_nvim_conffiles },
        { "n", "<leader>dO", search_dotfiles },
      })

      --Extensions loading
      telescope.load_extension("ui-select")
    end,
    opts = function()
      local actions = require("telescope.actions")
      return {
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
        ["ui-select"] = actions.get_cursor({}),
      },
    }
  end,
}
