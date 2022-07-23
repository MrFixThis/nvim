require("nvim-treesitter.configs").setup({
  ensure_installed = {"lua", "go", "gomod", "java", "rust"},
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
