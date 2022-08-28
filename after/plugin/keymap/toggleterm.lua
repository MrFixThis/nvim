local set_keymap = require("mrfixthis.keymap").set_keymap
local terminal = require("toggleterm.terminal").Terminal

local spawn_term = function(cmd, dir)
  terminal:new({
    cmd = cmd,
    dir = dir or vim.fn.expand("%:p:h"),
    direction = "float",
    start_in_insert = true,
    close_on_exit = true,
  }):toggle()
end

local toggleterm_mappings = {
  {"n", "<leader>gg", function() spawn_term("lazygit") end},
}

set_keymap(toggleterm_mappings)