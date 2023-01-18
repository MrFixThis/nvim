local secure_require = require("mrfixthis.tools").general.secure_require
local report, tree_sitter = secure_require("nvim-treesitter.configs")
if report then
  report(); return
end

--Treesitter settings
tree_sitter.setup({
  ensure_installed = {
    "lua", "vim", "rust", "toml", "go", "gomod", "java", "python", "bash",
    "c", "cpp", "javascript", "typescript", "json", "dockerfile", "http",
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
