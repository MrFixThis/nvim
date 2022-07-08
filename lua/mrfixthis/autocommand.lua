local api = vim.api

local auto_groups = {
  jdtls_lsp = {
    autocmd = {
      {
        event = { "FileType", },
        pattern = { "java", },
        callback = require("mrfixthis.lsp.lsp_config").setup_jdtls
      },
    },
    opts = {
        clear = true,
    }
  },
  higy = {
    autocmd = {
      {
        event = { "TextYankPost", },
        pattern = { "*", },
        command = "silent! lua vim.highlight.on_yank({timeout = 40})",
      },
    },
    opts = {
      clear = true,
    }
  },
}

--Auto_cammads group creation
for gp, configs in pairs(auto_groups) do
  --Group
  local group = api.nvim_create_augroup(gp, configs.opts)

  --Autocmd group creation
  for _, autocmd in pairs(configs.autocmd) do
    api.nvim_create_autocmd(autocmd.event, {
      pattern = autocmd.pattern,
      command = autocmd.command,
      callback = autocmd.callback,
      group = group
    })
  end
end
