local M = {}

--Leader and local leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

--Keymap setter function
local function bind_opts(mode, extra_opts)
    extra_opts = extra_opts or {noremap = true, silent = true}

    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            extra_opts,
            opts or {}
        )
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

--All modes keymap setters
M.nmap = bind_opts("n", {noremap = false})
M.nnoremap = bind_opts("n")
M.inoremap = bind_opts("i")
M.vnoremap = bind_opts("v")
M.xnoremap = bind_opts("x")
M.snoremap = bind_opts("s")
M.tnoremap = bind_opts("t")

return M
