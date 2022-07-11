local create_autocmd = require("mrfixthis.autocmd").create_autocmd
local set_keymap = require("mrfixthis.keymap").set_keymap
local opt = {buffer = true}

--GoInstallBinaries to install all the necesary dependencies
  --{list,} to only install the desired ones
--GoUpdateBinaries to update the binaries to its lastest version

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
  {"n", "<CR>c", ":GoCodeActions<CR>", opt},
  {"n", "<CR>k", ":GoRun ", opt},
  {"n", "<CR>j", ":GoStop ", opt},
  {"n", "<CR>d", ":GoDoc", opt}, --<C-w>w
  {"n", "<CR>f", ":GoFmt -", opt},
  {"n", "<CR>b", ":GoImport<CR>", opt},
  {"n", "<CR>l", ":GoLint<CR>", opt},
  {"n", "<CR>t", ":GoModTidy<CR>", opt},
  {"n", "<CR>v", ":GoVet<CR>", opt},
  {"n", "<CR>m", ":GoModVendor<CR>", opt},
  {"n", "<CR>g", ":GoMockGen<CR>", opt},
  {"n", "<CR>a", ":GoAlt", opt},

  --Testing
  {"n", "<CR>z", ":GoTest ", opt}, --gotests and testify
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
