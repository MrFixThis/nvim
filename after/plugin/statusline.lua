local builtin = require("el.builtin")
local extensions = require("el.extensions")
local sections = require("el.sections")
local subscribe = require("el.subscribe")
local diagnostics = require("el.diagnostic")

local get_icon = subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, bufnr)
  local icon = extensions.file_icon(_, bufnr)
  if icon then
    return icon .. " "
  end

  return ""
end)

local git_branch = subscribe.buf_autocmd(
  "el_git_branch",
  "BufEnter",
  function(window, buffer)
    local branch = extensions.git_branch(window, buffer)
    if branch then
      return " " .. extensions.git_icon() .. " " .. branch
    end
  end
)

local git_changes = subscribe.buf_autocmd(
  "el_git_changes",
  "BufWritePost",
  function(window, buffer)
    return extensions.git_changes(window, buffer)
  end
)

local lsp_diagnostics = diagnostics.make_buffer(function(_, _, counts)
  local items = {}
  local result = ""

  if counts.errors > 0 then
    table.insert(items, string.format("E:%s", counts.errors))
  end

  if counts.warnings > 0 then
    table.insert(items, string.format("W:%s", counts.warnings))
  end

  if counts.infos > 0 then
    table.insert(items, string.format("I:%s", counts.infos))
  end

  if counts.hints > 0 then
    table.insert(items, string.format("H:%s", counts.hints))
  end

  result = vim.fn.trim(table.concat(items, " "))

  if vim.fn.len(result) > 0 then
    return string.format("[%s]", result)
  end

  return ""
end)

require('el').setup {
  generator = function(_, _)
    return {
      extensions.gen_mode { format_string = "[ %s ]" },
      git_branch,
      " ",
      sections.split,
      get_icon,
      sections.maximum_width(builtin.make_responsive_file(140, 90), 0.30),
      sections.collapse_builtin {
        " ",
        builtin.modified_flag
      },
      sections.split,
      lsp_diagnostics,
      git_changes,
      "[", os.getenv('USER') , "]",
      "[", builtin.line_with_width(3), ":",  builtin.column_with_width(2), "]",
      sections.collapse_builtin {
        "[", builtin.help_list, builtin.readonly_list, "]",
      },
      builtin.filetype,
    }
  end
}
