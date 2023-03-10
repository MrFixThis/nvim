--Table inspection
T = function(...)
  local args = {...}
  for _, arg in ipairs(args) do
    print(vim.inspect(arg))
  end
  if #args == 1 then return args[1] end
  return args
end

--Module reload
RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end
