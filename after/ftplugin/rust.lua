local tools = require("mrfixthis.tools").general
local report, rust_tools = tools.secure_require("rust-tools")
if report then
  report(); return
end

--Rust-tools mappings
local opt = {buffer = true}
tools.set_keymap({
  {"n", "<leader>cr", rust_tools.runnables.runnables,  opt},
  {"n", "<leader>co", rust_tools.debuggables.debuggables,  opt},
  {"n", "<leader>ct", rust_tools.open_cargo_toml.open_cargo_toml, opt},
  {"n", "<leader>cs", rust_tools.standalone.start_standalone_client, opt},
  {"n", "<leader>cc", rust_tools.workspace_refresh.reload_workspace, opt},
})
