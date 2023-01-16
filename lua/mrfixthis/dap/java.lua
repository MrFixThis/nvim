local secure_require = require("mrfixthis.tools").general.secure_require
local report, dap = secure_require("dap")
if report then
  report(); return
end

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
