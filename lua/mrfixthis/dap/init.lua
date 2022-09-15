local M = {}
local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

--Dap ui and dap virtual_text setup
daptext.setup()
dapui.setup({
    mappings = {
      --Use a table to apply multiple mappings
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
            --Elements can be strings or table with id and size keys.
            "watches",
            {id = "scopes", size = 0.34},
            {id = "stacks", size = 0.34},
          },
          size = 38,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 10,
          position = "bottom",
        },
    },
})

local ui_opt = {reset = true}
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open(ui_opt)
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close(ui_opt)
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close(ui_opt)
end

--Adapters setup
local adapters = {
  "lua",
  "go",
  "lldb",
  "java",
  "node",
}

for _, v in ipairs(adapters) do
  require(string.format("mrfixthis.dap.%s", v))
end

return M
