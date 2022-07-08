local globals = {}

--option setting
function globals.opts(opts_table)
  if next(opts_table) == nil then return end
  for k, v in pairs(opts_table) do
   vim.opt[k] = v
  end
end

--Table inspect
P = function(v)
  print(vim.inspect(v))
  return v
end

--Reloading
RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

return globals
