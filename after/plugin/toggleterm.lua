local tools = require("mrfixthis.tools").general
local report, mods = tools.secure_require({
  "toggleterm",
  "toggleterm.terminal",
  "nebulous.functions",
})
if report then
  report(); return
end

local scheme = mods.nebulous_functions.get_colors("midnight")
mods.toggleterm.setup({
  -- size can be a number or function which is passed the current terminal
  size = 20,
  open_mapping = [[<A-t>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
  direction = "float",
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  auto_scroll = true, -- automatically scroll to the bottom on terminal output
  highlights = {
    FloatBorder = {
      guifg = scheme.DarkOrange
    },
  },
  float_opts = {
    border = "curved",
    winblend = 0,
  },
  winbar = {
    enabled = false,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
})

--Toggle term keymaps
local spawn_term = function(cmd, dir)
  mods.toggleterm_terminal.Terminal:new({
    cmd = cmd,
    dir = dir or vim.fn.expand("%:p:h"),
    direction = "float",
    start_in_insert = true,
    close_on_exit = true,
  }):toggle()
end

tools.set_keymap({
  {"n", "<localleader>gg", function() spawn_term("lazygit") end},
  {"n", "<localleader>gd", function() spawn_term("lazydocker") end},
})
