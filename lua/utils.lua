local M = {}

--Editor's settings setter
M.setting = function(opts_table)
  if next(opts_table) == nil then return end
  for k, v in pairs(opts_table) do
   vim.opt[k] = v
  end
end

-- Secure require
local report_counter = 0
M.secure_require = function(modules)
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
local default_opts = { noremap = true, silent = true }
M.set_keymap = function(keymap_set)
  for _, keymap in ipairs(keymap_set) do
    local mode, lhs, rhs, opts = unpack(keymap)
    opts = opts or {}
    --Opt merging
    opts = vim.tbl_extend("force", default_opts, opts)

    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

return M
