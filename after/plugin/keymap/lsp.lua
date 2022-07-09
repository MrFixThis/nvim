local set_keymap = require("mrfixthis.keymap").set_keymap

local lsp_maps = {
  {"n", "gD", "<cmd>lua vim.lsp.buf.declaration()"},
  {"n", "<leader>du", "<cmd>lua vim.lsp.buf.definition()"},
  {"n", "<leader>re", "<cmd>lua vim.lsp.buf.references()"},
  {"n", "<leader>vi", "<cmd>lua vim.lsp.buf.implementation()"},
  {"n", "<leader>sh", "<cmd>lua vim.lsp.buf.signature_help()"},
  {"n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()"},
  {"n", "<leader>gw", "<cmd>lua vim.lsp.buf.document_symbol()"},
  {"n", "<leader>gW", "<cmd>lua vim.lsp.buf.workspace_symbol()"},

  --Actions mappings
  {"n", "<leader>ah", "<cmd>lua vim.lsp.buf.hover()"},
  {"n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()"},
  {"n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()"},

  -- Few language severs support these three
  {"n", "<leader>=",  "<cmd>lua vim.lsp.buf.formatting()"},
  {"n", "<leader>ai", "<cmd>lua vim.lsp.buf.incoming_calls()"},
  {"n", "<leader>ao", "<cmd>lua vim.lsp.buf.outgoing_calls()"},

  -- Diagnostics mapping
  {"n", "<leader>ee", "<cmd>lua vim.diagnostic.open_float()"},
  {"n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()"},
  {"n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()"},

  --custom functions
  {"n", "<leader>ne", "<cmd>lua require('mrfixthis.lsp.util').diagnostics_qfixlist()"},
}

-- set_keymap(lsp_maps)
