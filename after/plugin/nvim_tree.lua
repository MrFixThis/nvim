--Nvim-tree settings
  -- Disabling netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  update_cwd = true,
  renderer = {
    indent_markers = {
      enable = true,
    },
  },
  actions = {
    file_popup = {
      open_win_config = {
       border = "rounded",
       zindex = 200,
      },
    },
    open_file = {
      quit_on_open = true,
    },
  },
  filters = {
    dotfiles = true,
  },
  notify = {
    threshold = 5
  },
  view = {
    adaptive_size = true,
    width = 32,
    hide_root_folder = false,
    side = "right",
    number = true,
    relativenumber = true,
    signcolumn = "no",
    float = {
      enable = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 32,
        height = 29,
        row = 2,
        col = 0xF423F, -- -1
      },
    },
    mappings = {
      list = {
        {key = "<CR>",    action = "edit"},
        {key = "t",       action = "edit"},
        {key = "<C-]>",   action = "cd"},
        {key = "<C-v>",   action = "vsplit"},
        {key = "<C-s>",   action = "split"},
        {key = "<C-t>",   action = "tabnew"},
        {key = "<",       action = "prev_sibling"},
        {key = ">",       action = "next_sibling"},
        {key = "<BS>",    action = "close_node"},
        {key = "h",       action = "close_node"},
        {key = "<Tab>",   action = "preview"},
        {key = "I",       action = "toggle_ignored"},
        {key = ".",       action = "toggle_dotfiles"},
        {key = "R",       action = "refresh"},
        {key = "a",       action = "create"},
        {key = "<S-D>",   action = "remove"},
        {key = "r",       action = "rename"},
        {key = "<C-r>",   action = "full_rename"},
        {key = "x",       action = "cut"},
        {key = "c",       action = "copy"},
        {key = "p",       action = "paste"},
        {key = "[c",      action = "prev_git_item"},
        {key = "]c",      action = "next_git_item"},
        {key = "T",       action = "expand_all"},
        {key = "H",       action = "collapse_all"},
        {key = "-",       action = "dir_up"},
        {key = "q",       action = "close"},
      },
    },
  },
})
