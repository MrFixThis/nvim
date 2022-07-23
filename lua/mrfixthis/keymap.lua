local M = {}

--Leader and local leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

--Default options
local default_opt = {noremap = true, silent = true}

function M.set_keymap(keymap_set)
  for _, keymap in ipairs(keymap_set) do
    local mode, lhs, rhs, opt = unpack(keymap)
    opt = opt or {}
    --Opt merging
    opt = vim.tbl_extend("force", default_opt, opt)

    vim.keymap.set(mode, lhs, rhs, opt)
  end
end

return M
