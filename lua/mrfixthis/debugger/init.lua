local M = {}
local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

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

return M
