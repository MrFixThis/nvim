return {
  --Mason

  --Lsp
  "neovim/nvim-lspconfig",
  "nvim-lua/plenary.nvim",
  "mfussenegger/nvim-jdtls",
    -- Snippets
  "rafamadriz/friendly-snippets",
  "hrsh7th/vim-vsnip",
    --Completion
  {
    "hrsh7th/nvim-cmp",
    load = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-vsnip",

    }
  },

  --Lang tools
    --Go
  "ray-x/go.nvim",
    --Rust
  "simrat39/rust-tools.nvim",
}
