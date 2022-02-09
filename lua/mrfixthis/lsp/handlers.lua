--diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
     underline = true,
     virtual_text = true,
     signs = true,
     update_in_insert = false,
     --virtual_text = {
       ----spacing = 4,
       ----prefix = '',
     --},
    }
)

--TODO: ovrride code_action handler
