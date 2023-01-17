local tools = require("mrfixthis.tools").general
local report, mods = tools.secure_require({
  "telescope",
  "telescope.builtin",
  "telescope.actions",
  "telescope.themes",
})
if report then
  report(); return
end

--Telescope setup
mods.telescope.setup({
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
          mods.telescope_actions.delete_buffer(prompt_bufnr)
        end,
      },
    },
  },
  extensions = {
    ["ui-select"] = mods.telescope_themes.get_cursor({}),
  },
})

-- Custom pickers
  --Nvim config files
local search_nvim_conffiles = function ()
  local set_pick = mods.telescope_themes.get_dropdown({
    prompt_title = "< Nvim config-files >",
    cwd = "~/.dotfiles/nvim/.config/nvim/",
    hidden = false,
    previewer = false,
    file_ignore_patterns = {"%.git"},
  })
  mods.telescope_builtin.find_files(set_pick)
end

  --.dotfiles
local search_dotfiles = function()
  local set_pick = mods.telescope_themes.get_dropdown({
    prompt_title = "< Dotfiles >",
    cwd = "~/.dotfiles/",
    hidden = true,
    previewer = false,
    file_ignore_patterns = {"nvim", "%.git"},
  })
  mods.telescope_builtin.find_files(set_pick)
end

--Telescope keymaps
tools.set_keymap({
  {"n", "<leader>tt", ":Telescope<CR>"},
  {"n", "<leader>mw", mods.telescope_builtin.buffers},
  {"n", "<leader>mk", mods.telescope_builtin.git_files},
  {"n", "<leader>th", mods.telescope_builtin.help_tags},
  {"n", "<leader>gs", mods.telescope_builtin.find_files},
  {"n", "<C-n>", mods.telescope_builtin.diagnostics},
  {"n", "<leader>gr", mods.telescope_builtin.live_grep},
  {"n", "<leader>re", mods.telescope_builtin.lsp_references},
  {"n", "<leader>pw",
    function() mods.telescope_builtin.grep_string({search = vim.fn.expand("<cword>")}) end
  },
  {"n", "<leader>ps",
    function() mods.telescope_builtin.grep_string({search = vim.fn.input("Grep For > ")}) end
  },
  --Custom telescope functions
  {"n", "<leader>do", search_nvim_conffiles},
  {"n", "<leader>dO", search_dotfiles},
})

--Extensions loading
mods.telescope.load_extension("ui-select")
