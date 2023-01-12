local execute = vim.api.nvim_command
local installation_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(installation_path)) > 0 then
  print("Installing Packer.nvim...")
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. installation_path)
  execute("packadd packer.nvim")
end

return require("packer").startup(function(use)

  local local_use = function(plug_path)
    if vim.fn.isdirectory(vim.fn.expand("~/Plugins/" .. plug_path)) == 1 then
      use("~/Plugins/" .. plug_path)
    else
      use(string.format("%s/%s", os.getenv("HOME"), plug_path))
    end
  end

  --Plugin manager
  use("wbthomason/packer.nvim")

  --Formating
  use("numToStr/Comment.nvim")
  use("tpope/vim-surround")
  use("alvan/vim-closetag")
  use("mhartington/formatter.nvim")

  --Interface
  use({
    "nvim-lualine/lualine.nvim",
    commit = "5f68f070e4f7158517afc55f125a6f5ed1f7db47",
  })
    --Themes
  use("Yagua/nebulous.nvim")
  -- use("eddyekofo94/gruvbox-flat.nvim")
  -- use("gruvbox-community/gruvbox")
    -- Icons
  use("ryanoasis/vim-devicons")
  use("kyazdani42/nvim-web-devicons")
  use("onsails/lspkind-nvim")

  --Navigation
  use("kyazdani42/nvim-tree.lua")
  use("szw/vim-maximizer")
  -- use("ThePrimeagen/harpoon")

  --Tools
  use("mbbill/undotree")
  use({"akinsho/toggleterm.nvim", tag = "v2.*"})
  use("NTBBloodbath/rest.nvim")
  use("norcalli/nvim-colorizer.lua")
  use({"iamcco/markdown-preview.nvim", run = "cd app && npm install"})
  use("lewis6991/gitsigns.nvim")
  use("sindrets/diffview.nvim")

  --Telescope
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
  })

  --Lsp
  use("neovim/nvim-lspconfig")
  use("nvim-lua/plenary.nvim")
  use("mfussenegger/nvim-jdtls")
    --Completion
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua")
  use("hrsh7th/cmp-vsnip")
    -- Snippets
  use("rafamadriz/friendly-snippets")
  use("hrsh7th/vim-vsnip")

  --Debugging
  use("mfussenegger/nvim-dap")
  use("rcarriga/nvim-dap-ui")
  use("theHamsta/nvim-dap-virtual-text")
    --Lua debugger adapter
  use("jbyuki/one-small-step-for-vimkind")

  --Lang tools
    --Go
  use("ray-x/go.nvim")
    --Rust
  -- use("simrat39/rust-tools.nvim")

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function() vim.cmd[[TSUpdate]] end,
  })
  use("nvim-treesitter/playground")

  -- -- Local plugins
  -- local_use("nvim-tree.lua")
end)
