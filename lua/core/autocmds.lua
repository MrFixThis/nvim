local opts = { clear = true }
require("utils").create_autocmd({
  --Yanking settings
  highlight_yank = {
    autocmd = {
      {
        event = { "TextYankPost", },
        pattern = { "*", },
        callback = function() vim.highlight.on_yank({ timeout = 40 }) end,
      },
    },
    opts = opts
  },
})
