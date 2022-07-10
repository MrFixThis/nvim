local set_keymap = require("mrfixthis.keymap").set_keymap
local custom_func = require("mrfixthis.lsp.tools")
local jdtls = require("jdtls")

local lsp_maps = {
  {"n", "gD", vim.lsp.buf.declaration},
  {"n", "<leader>du", vim.lsp.buf.definition},
  {"n", "<leader>re", vim.lsp.buf.references},
  {"n", "<leader>vi", vim.lsp.buf.implementation},
  {"n", "<leader>sh", vim.lsp.buf.signature_help},
  {"n", "<leader>gt", vim.lsp.buf.type_definition},
  {"n", "<leader>gw", vim.lsp.buf.document_symbol},
  {"n", "<leader>gW", vim.lsp.buf.workspace_symbol},

  --Actions mappings
  {"n", "<leader>ah", vim.lsp.buf.hover},
  {"n", "<leader>ca", vim.lsp.buf.code_action},
  {"n", "<leader>rn", vim.lsp.buf.rename},

  -- Few language severs support these three
  {"n", "<leader>=",  vim.lsp.buf.formatting},
  {"n", "<leader>ai", vim.lsp.buf.incoming_calls},
  {"n", "<leader>ao", vim.lsp.buf.outgoing_calls},

  --Diagnostics mappings
  {"n", "<leader>ee", vim.diagnostic.open_float},
  {"n", "<leader>gp", vim.diagnostic.goto_prev},
  {"n", "<leader>gn", vim.diagnostic.goto_next},

  --Cstom function mappings
  {"n", "<leader>ne", custom_func.diagnostics_qfixlist},

  --Languague servers keymaps
  --Jdtls
  {"n", "<leader>or", jdtls.organize_imports},
  {"n", "<leader>av", jdtls.test_class},
  {"n", "<leader>tm", jdtls.test_nearest_method},
  {"v", "<leader>am", function() jdtls.extract_variable(true) end},
  {"n", "<leader>am", jdtls.extract_variable},
  {"n", "<leader>om", jdtls.extract_constant},
  {"v", "<leader>dm", function() jdtls.extract_method(true) end},
}

set_keymap(lsp_maps)
