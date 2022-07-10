local create_autocmd = require("mrfixthis.autocmd").create_autocmd
local set_keymap = require("mrfixthis.keymap").set_keymap
local opt = {buffer = true}

--GoInstallBinaries to install all the necesary dependencies
--GoInstallBinaries to update the binaries to its lastest version

local buff_go_nvim_maps = {
  --General
  {"n", "<localleader>c", ":GoCmt<CR>", opt},
  {"n", "<localleader>t", ":GoAddTag<CR>", opt},
  {"n", "<localleader>T", ":GoRmTag<CR>", opt},
  {"n", "<localleader>r", ":GoIfErr<CR>", opt},
  {"n", "<localleader>s", ":GoFillStruct<CR>", opt},
  {"n", "<localleader>l", ":GoFillSwitch<CR>", opt},
  {"n", "<localleader>f", ":GoFixPlurals<CR>", opt},
  {"n", "<localleader>g", ":GoImpl", opt},

  --Tools
  {"n", "<localleder><leader>c", ":GoCodeActions<CR>", opt},
  {"n", "<localleder><leader>s", ":GoFmt -", opt},
  {"n", "<localleder><leader>f", ":GoImport<CR>", opt},
  {"n", "<localleder><leader>b", ":GoCheat<CR>", opt},
  {"n", "<localleder><leader>d", ":GoDoc", opt},
  {"n", "<localleder><leader>i", ":GoModInit<CR>", opt},
  {"n", "<localleder><leader>t", ":GoModTidy<CR>", opt},
  {"n", "<localleder><leader>v", ":GoVet<CR>", opt},
  {"n", "<localleder><leader>m", ":GoModVendor<CR>", opt},
  {"n", "<localleder><leader>a", ":GoAlt", opt},

  --Testing
  {"n", "<localleader><leader>t", ":GoTest ", opt}, --gotests and testify
  {"n", "<localleader>q", ":GoTermClose<CR>", opt},
}

--Autocommand creation
local go_nvim_aucmd = {
  go_nvim = {
    autocmd = {
      {
        event = {"FileType",},
        pattern = {"go", "gomod", "gotmpl",},
        callback = function() set_keymap(buff_go_nvim_maps) end,
      }
    },
    opts = {
      clear = true,
    }
  }
}

create_autocmd(go_nvim_aucmd)
