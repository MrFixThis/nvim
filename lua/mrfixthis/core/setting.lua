local settings = require("mrfixthis.global").opt

--Editor's global settings
settings({
  cursorline     = true,         -- Highlight the current line
  showmatch      = true,         -- show matching brackets when text indicator is over them
  relativenumber = true,         -- Show line numbers
  number         = true,         -- Show the actual number
  showcmd        = true,         -- Show partial commands at the bottom of screen
  hidden         = true,         -- Keep multiple buffers open
  smartindent    = true,         -- Makes indenting smart
  mouse          = "",           -- Disable all the mouse support
  expandtab      = true,         -- Converts tabs to spaces
  undofile       = true,         -- Reverse change in future sessions
  incsearch      = true,         -- Make the search mode more convenient (like a browser)
  termguicolors  = true,         -- Better color support (most terminal support this)
  list           = true,         -- Enable listchars
  hlsearch       = false,        -- Disable permant highlight of searches
  wrap           = false,        -- Don't wrap long lines
  swapfile       = false,        -- Don't store changes in a swap file.
  backup         = false,        -- Don't create backups files
  showmode       = false,        -- Don't show the current mode
  tabstop        = 4,            -- Number of spaces that a <Tab> in the file counts for
  softtabstop    = 4,            -- Number of spaces that a <Tab> counts in <Tab> or <BS>.
  shiftwidth     = 4,            -- Number of spaces to use for each step of (auto)indent.
  cmdheight      = 1,            -- Height of the command bar
  scrolloff      = 10,           -- Limit number of the scroll action
  splitbelow     = true,         -- Sets the horizontal split's position to bottom
  splitright     = true,         -- Sets the vertical split's position to right
  updatetime     = 50,           -- Make updates happen faster
  laststatus     = 3,            -- Set globlal status bar
  colorcolumn    = "80",         -- Set a column for 80 characters
  signcolumn     = "yes",        -- Always show the signcolumn
  clipboard      = "",           -- Copy paste between Vim and everything else
  listchars = {                  -- Custom listchars list
    trail = "𝁢",
    extends = "…",
    precedes = "…",
    conceal = "┊",
    nbsp = "☠",
    tab = "» ",
  },
  guicursor      = {"n-v-c:block-Cursor/lCursor", "i-ci-ve:ver25-Cursor2"}, --Cursor settigs
  formatoptions = vim.opt.formatoptions
    - "a" -- Auto formatting text
    - "t" -- Auto-wrap text using textwidth
    - "c" -- Auto-wrap comments using textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- Format text based on second line
})
