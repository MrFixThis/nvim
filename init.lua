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

-- General Modules
require('mrfixthis.plugins')
require('mrfixthis.options')

--Lsp Modules
require('mrfixthis.lsp')

--Telescope
require("mrfixthis.telescope")

--dap
require("mrfixthis.dap")
