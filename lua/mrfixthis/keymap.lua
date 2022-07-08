local M = {}

--Leader and local leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

--Keymap setter function
local function keymap_setter(mode, extra_opts)
    extra_opts = extra_opts or { noremap = true }

    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            extra_opts,
            opts or {}
        )
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

--All modes keymap setters
M.nmap = keymap_setter("n", { noremap = false })
M.nnoremap = keymap_setter("n")
M.inoremap = keymap_setter("i")
M.vnoremap = keymap_setter("v")
M.xnoremap = keymap_setter("x")
M.snoremap = keymap_setter("s")
M.tnoremap = keymap_setter("t")

return M
