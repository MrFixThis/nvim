local secure_require = require("mrfixthis.tools").general.secure_require
local report, mods = secure_require({"dap", "dap.utils"})
if report then
  report(); return
end

local home = os.getenv("HOME")
--Nodejs debugger adapter settings
mods.dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = {home .. "/.local/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js"},
}

mods.dap.configurations.javascript = {
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
    processId = mods.dap_utils.pick_process,
  },
}

mods.dap.configurations.typescript = {
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
