local dap = require("dap")

--Lua debugger adapter settings
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
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    port = 44444,
  }
}
