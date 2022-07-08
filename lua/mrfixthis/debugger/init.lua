local M = {}
local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

local remap = require("mrfixthis.keymap")
local nnoremap = remap.nnoremap

--Dap ui and dap virtual_text setup
daptext.setup()
dapui.setup({
    layouts = {
        {
          elements = {
              "console",
          },
          size = 7,
          position = "bottom",
        },
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = "scopes", size = 0.25 },
            "watches",
          },
          size = 40,
          position = "left",
        }
    },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open(1)
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

--Adapters setup
require("mrfixthis.debugger.go")
require("mrfixthis.debugger.java")
require("mrfixthis.debugger.lua")

--Dap keymaps
nnoremap("<Home>", function() dapui.toggle(1) end)
nnoremap("<End>", function() dapui.toggle(2) end)
nnoremap("<F4>", function() dap.terminate() end)
nnoremap("<localleader><leader>", function() dap.close() end)
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

return M
