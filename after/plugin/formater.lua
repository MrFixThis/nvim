require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
        -- prettier
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
          stdin = true
        }
      end
    },
  }
})

--Format on save
--vim.api.nvim_exec([[
--augroup FormatAutogroup
  --autocmd!
  --autocmd BufWritePost *.js,*.rs,*.lua FormatWrite
--augroup END
--]], true)

local options = {expr = false, silent = true, noremap = true}
vim.api.nvim_set_keymap("n", "<leader>fo", ":Format<CR>", options)
