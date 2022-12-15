local M = {}

-- Sessions
local base_session_dir = vim.fn.expand("~/.local/state/nvim/sessions")
local session_file_name = "session.vim"

function M.save_session()
  if vim.fn.isdirectory(base_session_dir) ~= 1 then
    vim.cmd(string.format("silent! !mkdir -p %s", base_session_dir))
  end
  vim.cmd("silent! write")
  vim.cmd(string.format("silent! mksession! %s/%s",
    base_session_dir, session_file_name))
end

function M.load_session()
  local sf_path = string.format("%s/%s", base_session_dir, session_file_name)
  if vim.fn.filereadable(sf_path) ~= 1 then
    print("There is no previous session")
    return
  end
  vim.cmd(string.format("so %s", sf_path))
end

return M
