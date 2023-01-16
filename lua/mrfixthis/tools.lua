local M = {
  general = {},
  session = {},
}

--Editor's settings setter
M.general.setting = function(opts_table)
  if next(opts_table) == nil then return end
  for k, v in pairs(opts_table) do
   vim.opt[k] = v
  end
end

-- Secure require
local report_counter = 0
M.general.secure_require = function(modules)
  local report = ""
  local reporter = function()
    report_counter = report_counter + 1
    local location = debug.getinfo(2, "S").source:match("^.+/nvim/(.+/.+)$")
    local final_msg = "Interrumping file execution..."
    report = string.format("[Secure require -> (%d)]: %s\n%s=> %s",
      report_counter, location, report, final_msg)
    vim.notify(report, 3)
  end

  local mods_loaded = {}
  local mod_type = type(modules)
  if mod_type ~= "string" and mod_type ~= "table" then
    report = string.format("=> Lua string|table expected, got %s\n", mod_type)
    return reporter, mods_loaded
  end

  local sanitizer = function(name) return name:gsub("%p", "_"):lower() end
  local nilCounter = 0
  local org_name
  if mod_type == "string" then
    org_name = sanitizer(modules)
    modules = rawset({}, 1, modules)
  end
  for _, mod_name in ipairs(modules) do
    local has_item, item = pcall(require, mod_name)
    if not has_item then
      nilCounter = nilCounter + 1
      report = report .. string.format("  => Problems retrieving module '%s'\n",
        mod_name)
    else
      mods_loaded[sanitizer(mod_name)] = item
    end
  end

  if mods_loaded[org_name] then mods_loaded = mods_loaded[org_name] end
  if nilCounter > 0 then return reporter, mods_loaded end
  return nil, mods_loaded
end

--Keymaps builder
  --Default options
local default_opt = {noremap = true, silent = true}
M.general.set_keymap = function(keymap_set)
  for _, keymap in ipairs(keymap_set) do
    local mode, lhs, rhs, opt = unpack(keymap)
    opt = opt or {}
    --Opt merging
    opt = vim.tbl_extend("force", default_opt, opt)

    vim.keymap.set(mode, lhs, rhs, opt)
  end
end

--Autocmd builder
M.general.create_autocmd = function(aucmd_content)
  for gp_name, content in pairs(aucmd_content) do
    --Group
    local group = vim.api.nvim_create_augroup(gp_name, content.opts)

    --Autocmd creation
    for _, autocmd in pairs(content.autocmd) do
      vim.api.nvim_create_autocmd(autocmd.event,
      {
          pattern = autocmd.pattern,
          command = autocmd.command,
          callback = autocmd.callback,
          group = group,
      })
    end
  end
end

-- Sessions
local base_session_dir = vim.fn.expand("~/.local/state/nvim/sessions")
local session_file_name = "session.vim"

M.session.save_session = function()
  if vim.fn.isdirectory(base_session_dir) ~= 1 then
    vim.cmd(string.format("silent! !mkdir -p %s", base_session_dir))
  end
  vim.cmd("silent! write")
  vim.cmd(string.format("silent! mksession! %s/%s",
    base_session_dir, session_file_name))
end

M.session.load_session = function()
  local sf_path = string.format("%s/%s", base_session_dir, session_file_name)
  if vim.fn.filereadable(sf_path) ~= 1 then
    print("There is no previous session")
    return
  end
  vim.cmd(string.format("so %s", sf_path))
end

return M
