local load_opts = require("mrfixthis.globals").opts

--SETTINGS
load_opts {
  cursorline     = true,         -- Highlight the current line
  showmatch      = true,         -- show matching brackets when text indicator is over them
  relativenumber = true,         -- Show line numbers
  number         = true,         -- Show the actual number
  showcmd        = true,         -- Show partial commands at the bottom of screen
  hidden         = true,         -- Keep multiple buffers open
  smartindent    = true,         -- Makes indenting smart
  expandtab      = true,         -- Converts tabs to spaces
  undofile       = true,         -- Reverse change in future sessions
  incsearch      = true,         -- Make the search mode more convenient (like a browser)
  termguicolors  = true,         -- Better color support (most terminal support this)
  hlsearch       = false,        -- Disable permant highlight of searches
  wrap           = false,        -- Don't wrap long lines
  swapfile       = false,        -- Don't store changes in a swap file.
  backup         = false,        -- Don't create backups files
  showmode       = false,        -- Don't show the current mode
  tabstop        = 4,            -- Number of spaces that a <Tab> in the file counts for
  softtabstop    = 4,            -- Number of spaces that a <Tab> counts in <Tab> or <BS>.
  shiftwidth     = 4,            -- Number of spaces to use for each step of (auto)indent.
  cmdheight      = 2,            -- Height of the command bar
  scrolloff      = 10,           -- Limit number of the scroll action
  updatetime     = 50,           -- Make updates happen faster
  laststatus     = 3,            -- Set globlal split bar
  colorcolumn    = "80",         -- Set a column for 80 characters
  signcolumn     = 'yes',        -- Always show the signcolumn
  clipboard      = '',           -- Copy paste between Vim and everything else
  guicursor      = { 'n-v-c:block-Cursor/lCursor', 'i-ci-ve:ver25-Cursor2' }, --Cursor settigs
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
}
