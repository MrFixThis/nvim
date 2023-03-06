local secure_require = require("mrfixthis.tools").general.secure_require
local report, mods = secure_require({"cmp", "lspkind"})
if report then
  report(); return
end

vim.opt.completeopt = {"menu", "menuone", "noselect"}
mods.cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  mapping = mods.cmp.mapping.preset.insert({
      ["<C-f>"] = mods.cmp.mapping.scroll_docs(-2),
      ["<C-d>"] = mods.cmp.mapping.scroll_docs(2),
      ["<C-Space>"] = mods.cmp.mapping.complete(),
      ["<C-e>"] = mods.cmp.mapping.close(),
      ["<CR>"] = mods.cmp.mapping.confirm {
        behavior = mods.cmp.ConfirmBehavior.Insert,
        select = false
      },
    }),
    sources = mods.cmp.config.sources({
      {name = "nvim_lsp"},
      {name = "nvim_lua"},
      {name = "buffer", keyword_lenght = 5},
      {name = "path"},
      {name = "vsnip"},
    }),
   formatting = {
     format = mods.lspkind.cmp_format({
       with_text = true,
       menu = {
         buffer = "[Buff]",
         nvim_lsp = "[LSP]",
         nvim_lua = "[Api]",
         path = "[Path]",
         vsnip = "[Snip]",
       },
     }),
   },
   window = {
     completion = {
       border = "rounded",
     },
     documentation = {
      border = "rounded",
    },
   },
})
