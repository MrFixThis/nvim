local dap = require("dap")
local dapui = require("dapui")
local remap = require("mrfixthis.keymap")
local nnoremap = remap.nnoremap

local key_maps = {
  {
    "<leader>B",
    function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end
  },
  {"<leader>b", function() dap.toggle_breakpoint() end},
  {"<leader>E", function() dap.set_exception_breakpoints({"all"}) end},
  {"<leader>co", function() dap.continue() end},
  {"<leader>si", function() dap.step_into() end},
  {"<leader>so", function() dap.step_out() end},
  {"<leader>sq", function() dap.step_over() end},
  {"<leader>rc", function() dap.run_to_cursor() end},
  {"<leader>rl", function() dap.run_last() end},
  {"<localleader>.", function() dap.terminate() end},
  {"<leader><localleader>", function() dap.close() end},
  {"<Home>", function() dapui.toggle(1) end},
  {"<End>", function() dapui.toggle(2) end},
}

for _, keymap in ipairs(key_maps) do
  local lhs, rhs, opts = unpack(keymap)
  nnoremap(lhs, rhs, opts)
end
