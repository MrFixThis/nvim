local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")
local opts = {
  dev = {
    path = "~/Plugins/"
  },
  ui = {
    size = {width = 1, height = 1},
    border = "rounded",
  },
}

local plugins = {
    --Formating
    "numToStr/Comment.nvim",
    "tpope/vim-surround",
    "alvan/vim-closetag",
    "mhartington/formatter.nvim",

    --Interface
    {
      "nvim-lualine/lualine.nvim",
      commit = "5f68f070e4f7158517afc55f125a6f5ed1f7db47",
    },
      --Themes
    "Yagua/nebulous.nvim",
    -- "eddyekofo94/gruvbox-flat.nvim",
    -- "gruvbox-community/gruvbox",
      -- Icons
    "ryanoasis/vim-devicons",
    "kyazdani42/nvim-web-devicons",
    "onsails/lspkind-nvim",
    --Cosmetic
    "j-hui/fidget.nvim",

    --Navigation
    "kyazdani42/nvim-tree.lua",
    "szw/vim-maximizer",
    -- "ThePrimeagen/harpoon",

    --Tools
    "mbbill/undotree",
    "NTBBloodbath/rest.nvim",
    "norcalli/nvim-colorizer.lua",
    "lewis6991/gitsigns.nvim",
    "sindrets/diffview.nvim",
    {"akinsho/toggleterm.nvim", version = "v2.*"},
    {"iamcco/markdown-preview.nvim", run = "cd app && npm install"},

    --Telescope
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/popup.nvim",
        "nvim-telescope/telescope-fzy-native.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
      },
    },

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

    --Debugging
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
      --Lua debugger adapter,
    "jbyuki/one-small-step-for-vimkind",
    "mfussenegger/nvim-dap-python",

    --Lang tools
      --Go
    "ray-x/go.nvim",
      --Rust
    "simrat39/rust-tools.nvim",

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter" },
    "nvim-treesitter/playground",

    -- -- Local plugins
    {
      "nvim-tree.lua",
      dev = true,
    },
}

lazy.setup(plugins, opts)
