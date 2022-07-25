local M = {}
local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

--Dap ui and dap virtual_text setup
daptext.setup()
dapui.setup({
    mappings = {
      -- Use a table to apply multiple mappings
      expand = {"<Tab>",},
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            "watches",
            {id = "scopes", size = 0.34},
            {id = "stacks", size = 0.34},
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            "console",
            "repl",
          },
          size = 8,
          position = "bottom",
        },
    },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

--Adapters setup
require("mrfixthis.dap.go")
require("mrfixthis.dap.java")
require("mrfixthis.dap.lua")

return M
