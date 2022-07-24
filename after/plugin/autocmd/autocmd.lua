local create_autocmd = require("mrfixthis.autocmd").create_autocmd

--General autocmds
local auto_groups = {
  --Java files. Language server attachment
  jdtls_lsp = {
    autocmd = {
      {
        event = {"FileType",},
        pattern = {"java",},
        callback = require("mrfixthis.lsp.lsp").setup_jdtls
      },
    },
    opts = {
        clear = true,
    }
  },
  --Yanking settings
  highlight_yank = {
    autocmd = {
      {
        event = {"TextYankPost",},
        pattern = { "*", },
        command = "silent! lua vim.highlight.on_yank({timeout = 40})",
      },
    },
    opts = {
      clear = true,
    }
  },
}

create_autocmd(auto_groups)
