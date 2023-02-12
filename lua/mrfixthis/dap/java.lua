local secure_require = require("mrfixthis.tools").general.secure_require
local _, dap = secure_require("dap")

--Java debugger adapter settings
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
