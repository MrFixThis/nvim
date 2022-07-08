local M = {}

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

M.nmap = keymap_setter("n", { noremap = false })
M.nnoremap = keymap_setter("n")
M.vnoremap = keymap_setter("v")
M.xnoremap = keymap_setter("x")
M.inoremap = keymap_setter("i")
M.tnoremap = keymap_setter("t")

return M
