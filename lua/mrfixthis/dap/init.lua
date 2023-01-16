local tools = require("mrfixthis.tools").general
local report, mods = tools.secure_require({
  "dap",
  "dapui",
  "nvim-dap-virtual-text"
})
if report then
  report(); return
end

local M = {}
--Dap ui and dap virtual_text setup
mods.nvim_dap_virtual_text.setup()
mods.dapui.setup({
  icons = {expanded = " ", collapsed = " ", current_frame = " " },
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
mods.dap.listeners.after.event_initialized["dapui_config"] = function()
    mods.dapui.open(ui_opt)
end
mods.dap.listeners.before.event_terminated["dapui_config"] = function()
    mods.dapui.close(ui_opt)
end
mods.dap.listeners.before.event_exited["dapui_config"] = function()
    mods.dapui.close(ui_opt)
end

--Keymaps
tools.set_keymap({
  {"n", "<leader>B",
    function() mods.dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end
  },
  {"n", "<leader>b", mods.dap.toggle_breakpoint},
  {"n", "<leader>E", function() mods.dap.set_exception_breakpoints({"all"}) end},
  {"n", "<leader>co", mods.dap.continue},
  {"n", "<leader>si", mods.dap.step_into},
  {"n", "<leader>so", mods.dap.step_out},
  {"n", "<leader>sq", mods.dap.step_over},
  {"n", "<leader>rc", mods.dap.run_to_cursor},
  {"n", "<leader>rf", mods.dap.restart_frame},
  {"n", "<leader>rl", mods.dap.run_last},
  {"n", "<leader><localleader>", mods.dap.terminate},
  {"n", "<leader>.", mods.dap.close},
  {"n", "<Home>", function() mods.dapui.toggle({layout = 1, reset = true}) end},
  {"n", "<End>", function() mods.dapui.toggle({layout = 2, reset = true}) end},
  {"n", "<leader>sw", function()
      if mods.dap.session() then
        vim.api.nvim_command("DapUiFloat")
      end
    end
  },
})

--Adapters setup
local adapters = {
  "lua",
  "java",
  "go",
  "node",
  "lldb",
}

for _, v in ipairs(adapters) do
  require(string.format("mrfixthis.dap.%s", v))
end

return M
