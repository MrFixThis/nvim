--[[

███╗░░░███╗██████╗░███████╗██╗██╗░░██╗████████╗██╗░░██╗██╗░██████╗
████╗░████║██╔══██╗██╔════╝██║╚██╗██╔╝╚══██╔══╝██║░░██║██║██╔════╝
██╔████╔██║██████╔╝█████╗░░██║░╚███╔╝░░░░██║░░░███████║██║╚█████╗░
██║╚██╔╝██║██╔══██╗██╔══╝░░██║░██╔██╗░░░░██║░░░██╔══██║██║░╚═══██╗
██║░╚═╝░██║██║░░██║██║░░░░░██║██╔╝╚██╗░░░██║░░░██║░░██║██║██████╔╝
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝╚═════╝░

--]]

--Leader and local leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Core config
require("core")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  dev = { path = "~/Plugins", },
  install = { colorscheme = { "nebulous", "tokyonight" } },
  defaults = { lazy = true },
  checker = { enabled = true },
  change_detection = { notify = false },
  diff = { cmd = "terminal_git", },
  debug = false,
  ui = {
    size = { width = 0.9, height = 0.9 },
    border = "rounded",
  },
  performance = {
    cache = {
      enabled = true,
    },
  },
})
