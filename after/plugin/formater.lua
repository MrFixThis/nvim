local set_keymap = require("mrfixthis.keymap").set_keymap

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

--Maps
local opt = {expr = false, silent = true, noremap = true}
local formater_maps = {
  {"n", "<leader>fo", ":Format<CR>", opt},
}

set_keymap(formater_maps)
