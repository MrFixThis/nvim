local g = vim.g

local function set_path(val)
  local home = os.getenv("HOME")
  local path = val or ""
  return string.format("%s/%s", home, path)
end

--set options
g.startify_enable_special = 0
g.startify_change_to_vcs_root = 1
g.startify_session_delete_buffers = 1
--g.webdevicons_enable_startify = 1
--g.startify_fortune_use_unicode = 1
--g.startify_custom_header = {}

--bookmarks variables
g.startify_bookmarks = {
  { ['i']  = set_path(".config/nvim/init.lua") },
  { ['o']  = set_path(".config/nvim/lua/mrfixthis/options.lua") },
  { ['p']  = set_path(".config/nvim/lua/mrfixthis/plugins.lua") },
  { ['z']  = set_path(".config/zsh/zshrc") },
  { ['w']  = set_path(".config/i3/config") },
}

--enable incons in startify
--vim.cmd([[
--function! StartifyEntryFormat()
  --return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
--endfunction
--]])
