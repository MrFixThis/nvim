--Nvim-tree settings
require("nvim-tree").setup({
  auto_reload_on_write = true,
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = true,
  actions = {
    file_popup = {
      open_win_config = {
       col = 1,
       row = 1,
       relative = "cursor",
       border = "rounded",
       style = "minimal",
       zindex = 200,
      },
    },
    open_file = {
      quit_on_open = true,
    },
  },
  diagnostics = {
    enable = false,
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        none = " ",
      },
    },
  },
  filters = {
    dotfiles = true,
    custom = {}
  },
  view = {
    width = 35,
    height = 30,
    hide_root_folder = false,
    side = "left",
    number = true,
    adaptive_size = true,
    relativenumber = true,
    signcolumn = "no",
    mappings = {
      custom_only = false,
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
        {key = "-",       action = "dir_up"},
        {key = "q",       action = "close"},
      },
    },
    float = {
      enable = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 33,
        height = 29,
        row = 2,
        col = 0xF423F, -- -1
      },
    },
  },
  log = {
    enable = false
  },
})
