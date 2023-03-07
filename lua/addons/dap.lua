local setup_adapters = function(dap)
  -- Lua
  dap.adapters.nlua = function(callback, config)
    local port = config.port
    local opts = {
      args = {
        "new-window",
        "-n", "[Lua Debugger]",
        vim.v.progpath,
        "-c", string.format("lua require('osv').launch({port = %d})", port),
      },
      cwd = vim.fn.getcwd(),
      detached = true
    }

    local handle
    local pid_or_err
    handle, pid_or_err = vim.loop.spawn("tmux", opts, function(code)
      handle:close()
      if code ~= 0 then
        print('nvim exited', code)
      end
    end)

    assert(handle, "Could not run command:" .. pid_or_err)
    vim.cmd("sleep")
    callback({ type = "server", host = "127.0.0.1", port = port })
  end

  dap.configurations.lua = {
    {
      name = "Attach to running Neovim instance",
      type = "nlua",
      request = "attach",
      port = 44444,
    }
  }

  -- lldb
  dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode",  --Adjust as needed, must be absolute path
    name = "lldb",
  }

  local configuration = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      runInTerminal = false,
      args = {},
    },
  }

  dap.configurations.rust = configuration
  dap.configurations.c = configuration
  dap.configurations.cpp = configuration

  -- Java
  dap.configurations.java = {
    {
      name = "Debug (Attach) - Remote",
      type = "java",
      request = "attach",
      hostName = "127.0.0.1",
      port = 5005,
    },
    {
      name = "Debug Non-Project class",
      type = "java",
      request = "launch",
      program = "${file}",
    },
  }

  -- Go
  dap.adapters.go = function(callback, _)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
      stdio = { nil, stdout },
      args = { "dap", "-l", "127.0.0.1:" .. port },
      detached = true,
    }

    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print("dlv exited with code", code)
      end
    end)

    assert(handle, "Error running dlv: " .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          dap.repl.append(chunk)
        end)
      end
    end)

    --Wait for delve to start
    vim.defer_fn(
      function()
        callback({ type = "server", host = "127.0.0.1", port = port })
      end,
    100)
  end

  dap.configurations.go = {
    {
      name = "Debug",
      type = "go",
      request = "launch",
      program = "${file}",
    },
    --Debug test files
    {
      name = "Debug test",
      type = "go",
      request = "launch",
      mode = "test",
      program = "${file}",
    },
  }

  -- Node
  local home = os.getenv("HOME")
  dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { home .. "/.local/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
  }

  dap.configurations.javascript = {
    {
      name = "Launch",
      type = "node2",
      request = "launch",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
    {
      -- For this to work you need to make sure the node process is
      -- started with the `--inspect` flag.
      name = "Attach to process",
      type = "node2",
      request = "attach",
      processId = require("dap.utils").pick_process,
    },
  }

  dap.configurations.typescript = {
    {
      name = "ts-node (Node2 with ts-node)",
      type = "node2",
      request = "launch",
      cwd = vim.loop.cwd(),
      runtimeExecutable = "node",
      runtimeArgs = { "-r", "ts-node/register" },
      args = { "--inspect", "${file}" },
      sourceMaps = true,
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      name = "Jest (Node2 with ts-node)",
      type = "node2",
      request = "launch",
      cwd = vim.loop.cwd(),
      runtimeExecutable = "node",
      runtimeArgs = { "--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest" },
      args = { "${file}", "--runInBand", "--coverage", "false" },
      sourceMaps = true,
      port = 9229,
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
  }

  -- Python
  require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        opts = {
          icons = { expanded = " ", collapsed = " ", current_frame = " "  },
          mappings = {
            --Use a table to apply multiple mappings
            expand = { "<Tab>", },
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
                { id = "scopes", size = 0.34 },
                { id = "stacks", size = 0.34 },
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
        }
      },
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      setup_adapters(dap)

      local ui_opts = { reset = true }
      dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open(ui_opts)
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close(ui_opts)
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close(ui_opts)
      end

      require("utils").set_keymap({
        { "n", "<leader>B",
          function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end
        },
        { "n", "<leader>b", dap.toggle_breakpoint },
        { "n", "<leader>E", function() dap.set_exception_breakpoints({ "all" }) end },
        { "n", "<leader>co", dap.continue },
        { "n", "<leader>si", dap.step_into },
        { "n", "<leader>so", dap.step_out },
        { "n", "<leader>sq", dap.step_over },
        { "n", "<leader>rc", dap.run_to_cursor },
        { "n", "<leader>rf", dap.restart_frame },
        { "n", "<leader>rl", dap.run_last },
        { "n", "<leader><localleader>", dap.terminate },
        { "n", "<leader>.", dap.close },
        { "n", "<Home>", function() dapui.toggle({ layout = 1, reset = true }) end },
        { "n", "<End>", function() dapui.toggle({ layout = 2, reset = true }) end },
        { "n", "<leader>sw", function()
            if dap.session() then
              vim.api.nvim_command("DapUiFloat")
            end
          end
        },
      })
    end,
  },

  -- Debug adapters
  "leoluz/nvim-dap-go",
  "mfussenegger/nvim-dap-python",
  "jbyuki/one-small-step-for-vimkind",
}
