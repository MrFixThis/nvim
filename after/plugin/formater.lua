local secure_require = require("mrfixthis.tools").general.secure_require
local report, formatter = secure_require("formatter")
if report then
  report(); return
end

--Formatter setup
formatter.setup({
  logging = false,
  filetype = {
    javascript = {
      -- prettier
      function()
        return {
          exe = "prettier",
          args = {
            "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"
          },
          stdin = true
        }
      end
    },
  },
})
