local secure_require = require("mrfixthis.tools").general.secure_require
local report, mods = secure_require({
  "Comment",
  "Comment.ft",
})
if report then
  report(); return
end

--Commenter setup
mods.comment.setup({
  ---Add a space b/w comment and the line
  padding = true,
  ---Whether the cursor should stay at its position
  sticky = false,
  ---Lines to be ignored while comment/uncomment.
  ignore = nil,
  ---LHS of toggle mappings in NORMAL + VISUAL mode
  ---@type table
  toggler = {
      ---line-comment keymap
      line = "gcc",
      ---block-comment keymap
      block = "ghc",
  },
  ---LHS of operator-pending mappings in NORMAL + VISUAL mode
  ---@type table
  opleader = {
      ---line-comment keymap
      line = "gc",
      ---block-comment keymap
      block = "gh",
  },
  ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
  mappings = {
      ---operator-pending mapping
      basic = true,
      ---extra mapping
      extra = true,
      ---extended mapping
      extended = false,
  },
  ---Pre-hook, called before commenting the line
  pre_hook = nil,
  ---Post-hook, called after commenting is done
  post_hook = nil,
})

--Custom comment placeholders
mods.comment_ft.http = "# %s"
mods.comment_ft.jsp =  "<%-- %s --%>"
