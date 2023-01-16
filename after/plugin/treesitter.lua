local secure_require = require("mrfixthis.tools").general.secure_require
local report, tree_sitter = secure_require("nvim-treesitter.configs")
if report then
  report(); return
end

--Treesitter settings
tree_sitter.setup({
  ensure_installed = {
    "lua", "vim", "go", "gomod", "java", "python", "rust", "javascript",
    "typescript", "http", "json", "dockerfile"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false
  },
})
