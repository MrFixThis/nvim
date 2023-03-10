return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "astro", "bash", "c", "cmake", "cpp", "css", "diff", "gitignore",
        "go", "graphql", "html", "http", "java", "javascript", "jsdoc",
        "jsonc", "latex", "lua", "markdown", "markdown_inline", "meson",
        "ninja", "python", "query", "regex", "rust", "scss", "sql", "svelte",
        "teal", "toml", "tsx", "typescript", "vhs", "vim", "vue", "wgsl",
        "yaml", "json",
      },
      matchup = { enable = true, },
      indent = { enable = true, disable = { "python" } },
      highlight = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
    },
  },

  "nvim-treesitter/playground",
}
