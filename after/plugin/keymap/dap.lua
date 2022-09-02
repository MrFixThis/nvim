local set_keymap = require("mrfixthis.keymap").set_keymap
local dap = require("dap")
local dapui = require("dapui")

--Dap keymaps
local dap_mappings = {
  {"n", "<leader>B",
    function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end
  },
  {"n", "<leader>b", dap.toggle_breakpoint},
  {"n", "<leader>E", function() dap.set_exception_breakpoints({"all"}) end},
  {"n", "<leader>co", dap.continue},
  {"n", "<leader>si", dap.step_into},
  {"n", "<leader>so", dap.step_out},
  {"n", "<leader>sq", dap.step_over},
  {"n", "<leader>rc", dap.run_to_cursor},
  {"n", "<leader>rl", dap.run_last},
  {"n", "<leader><localleader>", dap.terminate},
  {"n", "<leader>.", dap.close},
  {"n", "<Home>", function() dapui.toggle({layout = 1, reset = true}) end},
  {"n", "<End>", function() dapui.toggle({layout = 2, reset = true}) end},
  {"n", "<leader>sb", function()
      if dap.session() then
        local bp = vim.fn.sign_getplaced(0, {group = "dap_breakpoints"})
        if #bp[1].signs ~= 0 then dapui.float_element("breakpoints") end
      end
    end
  },
  {"n", "<leader>sw", function()
      if dap.session() then
        local isStoped = string.find(dap.status(), "Stopped")
        if isStoped then dapui.eval() end
      end
    end
  },
}

set_keymap(dap_mappings)
