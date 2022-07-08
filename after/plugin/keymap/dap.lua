local dap = require("dap")
local dapui = require("dapui")

local remap = require("mrfixthis.keymap")
local nnoremap = remap.nnoremap

nnoremap("<leader>B", function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
nnoremap("<leader>b", function() dap.toggle_breakpoint() end)
nnoremap("<leader>E", function() dap.set_exception_breakpoints({"all"}) end)
nnoremap("<leader>co", function() dap.continue() end)
nnoremap("<leader>so", function() dap.step_out() end)
nnoremap("<leader>si", function() dap.step_into() end)
nnoremap("<leader>sq", function() dap.step_over() end)
nnoremap("<leader>rc", function() dap.run_to_cursor() end)
nnoremap("<leader>rl", function() dap.run_last() end)
nnoremap("<F4>", function() dap.terminate() end)
nnoremap("<leader><leader>", function() dap.close() end)
nnoremap("<End>", function() dapui.toggle(1) end)
nnoremap("<Home>", function() dapui.toggle(2) end)
