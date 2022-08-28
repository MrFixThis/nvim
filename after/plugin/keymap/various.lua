local set_keymap = require("mrfixthis.keymap").set_keymap
local rest_nvim = require("rest-nvim")

--Single keymaps
local various_mappings = {
  --Nvim tree
  {"n", "<c-p>", ":NvimTreeToggle<CR>"},
  --Formatter
  {"n", "<leader>fo", ":Format<CR>"},
  --Undotree
  {"n", "<leader>u", ":UndotreeShow<CR>"},
  --Maximizer
  {"n", "<leader>ma", ":MaximizerToggle!<CR>"},
    --DiffView
  {"n", "<leader>go", ":DiffviewOpen<CR>"},
  {"n", "<leader>gh", ":DiffviewFileHistory<CR>"},
  {"n", "<leader>gq", ":DiffviewClose<CR>"},
  --Rest_nvim
  {"n", "<leader>rr", rest_nvim.run},
  {"n", "<leader>rR", function() rest_nvim.run(true) end},
  {"n", "<leader>rf", rest_nvim.last},
}

set_keymap(various_mappings)