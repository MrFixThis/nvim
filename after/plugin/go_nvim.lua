--Go.nvim setup
require("go").setup({
  go = "go", --"go"
  goimport = "gopls", --goimport + gofmt
  fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
  gofmt = "gofump", --can be gofmt
  max_line_len = 128, -- max line length in golines format, Target maximum line length for golines
  tag_transform = false, -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
  gotests_template = "",
  gotests_template_dir = "",
  comment_placeholder = "%" ,
  verbose = false,  -- output loginf in messages
  lsp_cfg = false, -- true: use non-default gopls setup specified in go/lsp.lua
                   -- false: do nothing
                   -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
                   --   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}

  lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
  lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua,
                       --      when lsp_cfg is true
                       -- if lsp_on_attach is a function: use this function as on_attach function for gopls

  lsp_keymaps = true, -- set to false to disable gopls/lsp keymap
  lsp_codelens = false, -- set to false to disable codelens, true by default, you can use a function
  lsp_diag_hdlr = true, -- hook lsp diag handler

  --Virtual text setup
  lsp_diag_virtual_text = {}, --empty table for default
  lsp_diag_signs = true,
  lsp_diag_update_in_insert = false,
  lsp_document_formatting = true, -- set to true: use gopls to format
                                  -- false if you want to use other formatter
                                  -- tool(e.g. efm, nulls)
  gopls_cmd = nil, -- if you need to specify gopls path and cmd
  gopls_remote_auto = "auto", -- add -remote=auto to gopls
  dap_debug = true, -- set to false to disable dap
  dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
                           -- false: do not use keymap in go/dap.lua.  you must define your own.
                           -- windows: use visual studio keymap
  dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
  dap_debug_vt = true, -- set to true to enable dap virtual text
  build_tags = "tag1,tag2", -- set default build tags
  textobjects = true, -- enable default text jobects through treesittter-text-objects
  test_runner = "go", -- one of {`go`, `richgo`, `dlv`, `ginkgo`}
  verbose_tests = true, -- set to add verbose flag to tests
  run_in_floaterm = true, -- set to true to run in float window. :GoTermClose closes the floatterm
                           -- float term recommand if you use richgo/ginkgo with terminal color

  test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
})
