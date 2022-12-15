local home = os.getenv("HOME")
local dap = require("dap")
local dap_utils = require("dap.utils")

--Nodejs debugger adapter settings
dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = {home .. "/.local/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js"},
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
    processId = dap_utils.pick_process,
  },
}

dap.configurations.typescript = {
  {
    name = "ts-node (Node2 with ts-node)",
    type = "node2",
    request = "launch",
    cwd = vim.loop.cwd(),
    runtimeExecutable = "node",
    runtimeArgs = {"-r", "ts-node/register"},
    args = {"--inspect", "${file}"},
    sourceMaps = true,
    skipFiles = {"<node_internals>/**", "node_modules/**"},
  },
  {
    name = "Jest (Node2 with ts-node)",
    type = "node2",
    request = "launch",
    cwd = vim.loop.cwd(),
    runtimeExecutable = "node",
    runtimeArgs = {"--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest"},
    args = {"${file}", "--runInBand", "--coverage", "false"},
    sourceMaps = true,
    port = 9229,
    skipFiles = {"<node_internals>/**", "node_modules/**"},
  },
}
