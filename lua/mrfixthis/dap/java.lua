local dap = require("dap")

dap.configurations.java = {
  {
    type = "java",
    name = "Debug (Attach) - Remote",
    request = "attach",
    hostName = "127.0.0.1",
    port = 5005,
  },
  {
    type = "java",
    name = "Debug Non-Project class",
    request = "launch",
    program = "${file}",
  },
}
