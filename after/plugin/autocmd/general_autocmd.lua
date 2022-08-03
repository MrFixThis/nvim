local create_autocmd = require("mrfixthis.autocmd").create_autocmd

--General autocmds
local general_aucmd = {
  --Yanking settings
  highlight_yank = {
    autocmd = {
      {
        event = {"TextYankPost",},
        pattern = { "*", },
        callback = function() vim.highlight.on_yank({timeout = 40}) end,
      },
    },
    opts = {
      clear = true,
    },
  },
}

create_autocmd(general_aucmd)