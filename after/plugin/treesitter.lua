--Treesitter settings
require("nvim-treesitter.configs").setup({
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
