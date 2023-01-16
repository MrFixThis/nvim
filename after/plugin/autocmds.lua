local tools = require("mrfixthis.tools").general
local report, lualine = tools.secure_require("lualine")
if report then
  report(); return
end

--General autocmds
local opts = {clear = true}
tools.create_autocmd({
  --Yanking settings
  highlight_yank = {
    autocmd = {
      {
        event = {"TextYankPost",},
        pattern = {"*",},
        callback = function() vim.highlight.on_yank({timeout = 40}) end,
      },
    },
    opts = opts
  },
  -- Custom refresh for lualine's components
    -- this aucmd is created to complement the 'default_refresh_events'
    -- defined by lualine in the commit 5f68f070e4f7158517afc55f125a6f5ed1f7db47
  lualine_custom_refresh = {
    autocmd = {
      {
        event = {
          "BufWritePost", "CursorMoved", "CursorMovedI",
          "CursorHold", "CursorHoldI",
        },
        pattern = {"*",},
        callback = function() lualine.refresh(
          {
            kind = "tabpage",
            place = {"statusline", "tabline", "winbar"},
            trigger = "autocmd"
          })
        end,
      },
    },
    opts = opts
  },
})
