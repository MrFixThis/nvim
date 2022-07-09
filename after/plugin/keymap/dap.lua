local set_keymap = require("mrfixthis.keymap").set_keymap
local dap = require("dap")
local dapui = require("dapui")

local dap_maps = {
  {"n", "<leader>B",
    function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end
  },
  {"n", "<leader>b", function() dap.toggle_breakpoint() end},
  {"n", "<leader>E", function() dap.set_exception_breakpoints({"all"}) end},
  {"n", "<leader>co", function() dap.continue() end},
  {"n", "<leader>si", function() dap.step_into() end},
  {"n", "<leader>so", function() dap.step_out() end},
  {"n", "<leader>sq", function() dap.step_over() end},
  {"n", "<leader>rc", function() dap.run_to_cursor() end},
  {"n", "<leader>rl", function() dap.run_last() end},
  {"n", "<localleader>.", function() dap.terminate() end},
  {"n", "<leader><localleader>", function() dap.close() end},
  {"n", "<Home>", function() dapui.toggle(1) end},
  {"n", "<End>", function() dapui.toggle(2) end},
}

set_keymap(dap_maps)
