local set_keymap = require("utils").set_keymap

-- Capabilities builder
local build_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument = {
    completion = {
      completionItem = {
        insertReplaceSupport = false,
      },
    },
    codeLens = {
      dynamicRegistration = false
    },
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
  }

  return capabilities
end

-- Default config builder
local build_default_config = function()
  return {
    flags = {
      debounce_text_changes = 100,
    },
    handlers = {},
    capabilities = build_capabilities(),
    init_options = {},
    settings = {},
  }
end

-- Servers setup
local setup_servers = function(servers)
  for server, config in ipairs(servers) do
    if config then
      if type(config) ~= "table" then config = {} end
      servers[server] = vim.tbl_deep_extend(
        "force", build_default_config(), config
      )
    end
  end

  return servers
end

return {
  --Mason
  {
    "williamboman/mason.nvim", -- TODO: configure
    opts = {
      ensure_installed = {
        "rustfmt", --...
      }
    }
  },

  --Lsp
  {
    "neovim/nvim-lspconfig",
    init = function()
      set_keymap({
        { "n", "gD", vim.lsp.buf.declaration, },
        { "n", "<leader>du", vim.lsp.buf.definition, },
        { "n", "<leader>re", vim.lsp.buf.references, },
        { "n", "<leader>vi", vim.lsp.buf.implementation, },
        { "n", "<leader>sh", vim.lsp.buf.signature_help, },
        { "n", "<leader>gt", vim.lsp.buf.type_definition, },
        { "n", "<leader>gw", vim.lsp.buf.document_symbol, },
        { "n", "<leader>gW", vim.lsp.buf.workspace_symbol, },
        --Actions mappings
        { "n", "<leader>ah", vim.lsp.buf.hover, },
        { "n", "<leader>ca", vim.lsp.buf.code_action, },
        { "n", "<leader>rn", vim.lsp.buf.rename, },
        -- Few language severs support these three
        { "n", "<leader>=", function() vim.lsp.buf.format({ async = true }) end, },
        { "n", "<leader>ai", vim.lsp.buf.incoming_calls, },
        { "n", "<leader>ao", vim.lsp.buf.outgoing_calls, },
        --Diagnostics mappings
        { "n", "<leader>ee", vim.diagnostic.open_float, },
        { "n", "<leader>gp", vim.diagnostic.goto_prev, },
        { "n", "<leader>gn", vim.diagnostic.goto_next, },
        --Custom
        { "n", "<leader>~", ":LspRestart<CR>", },
      })
    end,
    opt = setup_servers({
      tsserver = true,
      taplo = true,
      yamlls = true,
      vimls = true,
      cssls = true,

      --Lua
      lua_ls = {
        -- cmd = { lua_ls_binary },
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
              -- Setup your lua path
              path = vim.split(package.path, ";")
             },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" }
             },
            workspace = {
            -- Make the server aware of Neovim runtime files
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
               },
             },
            semantic = { enable = false },
            telemetry = {
              enable = false
             },
           },
         },
       },

      --Go
      gopls = {
        cmd = { "gopls", "serve" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        single_file_support = true,
        settings = {
          gopls = {
            gofumpt = true,
            analyses = {
              unusedparams = true,
             },
            staticcheck = true,
           },
         },
       },

      --Python
      pylsp = {
        plugins = {
          pyls_mypy = {
            enabled = true,
            live_mode = false,
           },
         },
       },

      --Html
      html = { filetypes = { "html", "jsp" } },
    }),
  },

  -- Rust tools
  {
    "simrat39/rust-tools.nvim",
    ft = "rs",
    config = function()
      local tools = require("rust-tools")
      local executors = require("rust-tools.executors")

      tools.setup({
        server = {
          capabilities = build_capabilities(),
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "self",
          },
          checkOnSave = {
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
          cargo = { allFeatures = true },
          procMacro = { enable = true },
          on_attach = function(bfnr)
            local opts = { buffer = bfnr }
            tools.set_keymap({
              { "n", "<leader>cr", tools.runnables.runnables,  opts },
              { "n", "<leader>cd", tools.debuggables.debuggables,  opts },
              { "n", "<leader>ct", tools.open_cargo_toml.open_cargo_toml, opts },
              { "n", "<leader>cs", tools.standalone.start_standalone_client, opts },
              { "n", "<leader>cc", tools.workspace_refresh.reload_workspace, opts },
            })
          end,
        },
        dap = {
          adapter = {
            type = "executable",
            command = "lldb-vscode",
            name = "rt_lldb",
          },
        },
        tools = {
          executor = executors.toggleterm,
          inlay_hints = {
            auto = false,
          },
        },
      })
    end,
  },

  -- Jdtls
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local jdtls = require("jdtls")
      local jdtls_dap = require("jdtls.dap")
      local config = build_default_config()
      local home = os.getenv("HOME")
      local root_markers = {  ".gradlew", ".mvnw", ".git",  }
      local root_dir = jdtls.setup.find_root(root_markers)
      local workspace_folder = string.format(
        "%s/.local/share/eclipse/%s",
        home, vim.fn.fnamemodify(root_dir, ":p:h:t")
      )

      --Capabilities
      local extendedClientCapabilities = jdtls.extendedClientCapabilities
      extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

      --Cmd
      config.cmd = {
        "/opt/jdks/jdk-17.0.4.1/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", vim.fn.glob(home .. "/.local/servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration", home .. "/.local/servers/jdtls/config_linux",
        "-data", workspace_folder,
       }
      --Lombok support
      local lombok_path = home .. "/.local/dev/java/bundles/lombok/lombok.jar"
      if vim.fn.filereadable(lombok_path) > 0 then
        table.insert(config.cmd, 2, string.format("-javaagent:%s", lombok_path))
      end

      --Settings
      config.settings = {
        java = {
          signatureHelp = {  enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.assertj.core.api.Assertions.assertThat",
              "org.assertj.core.api.Assertions.assertThatThrownBy",
              "org.assertj.core.api.Assertions.assertThatExceptionOfType",
              "org.assertj.core.api.Assertions.catchThrowable",
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*"
             },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
             },
           },
          configuration = {
            runtimes = {
              {
                name = "JavaSE-1.8",
                path = "/opt/jdks/jdk1.8.0_202/",
               },
              {
                name = "JavaSE-11",
                path = "/opt/jdks/jdk-11.0.16/",
               },
              {
                name = "JavaSE-14",
                path = "/opt/jdks/jdk-14.0.2/"
               },
              {
                name = "JavaSE-17",
                path = "/opt/jdks/jdk-17.0.4.1/"
               },
             },
           },
         },
       }

      --On_attach setup
      config.on_attach = function(_, bufnr)
        jdtls.setup_dap({ hotcodereplace = "auto" })
        jdtls_dap.setup_dap_main_class_configs()
        jdtls.setup.add_commands()

        local opt = { buffer = bufnr }
        set_keymap({
          { "n", "<leader>or", jdtls.organize_imports, opt },
          { "n", "<leader>am", jdtls.extract_variable, opt },
          { "n", "<leader>om", jdtls.extract_constant, opt },
          { "v", "<leader>am", "[[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]]", opt },
          { "v", "<leader>om", "[[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]]", opt },
          { "v", "<leader>dm", "[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]]", opt },

          --Test
          { "n", "<leader>tc", function()
              if vim.bo.modified then vim.cmd("w") end
              jdtls.test_class()
            end,
          opt },
          { "n", "<leader>tn", function()
              if vim.bo.modified then vim.cmd("w") end
              jdtls.test_nearest_method()
            end,
          opt },
        })
      end

      local bundles = {
        vim.fn.glob(
          home .. "/.local/dev/microsoft/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
        ),
      }
      vim.list_extend(
        bundles,
        vim.split(vim.fn.glob(home .. "/.local/dev/microsoft/vscode-java-test/server/*.jar"), "\n")
      )

      config.init_options = {
        bundles = bundles,
        extendedClientCapabilities = extendedClientCapabilities,
      }

      config.handlers["language/status"] = function() end

      --Setup client
      jdtls.start_or_attach(config)
    end,
  },

  -- Snippets
  {
    "hrsh7th/vim-vsnip",
    load = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snippet/vsnip")
      local opt = { expr = true, silent = false }
      set_keymap({
        { "i", "<C-q>", "vsnip#expandable() ? \'<Plug>(vsnip-expand)\'    : \'<C-k>\'", opt },
        { "i", "<C-k>", "vsnip#jumpable(1)  ? \'<Plug>(vsnip-jump-next)\' : \'<Tab>\'", opt },
        { "i", "<C-j>", "vsnip#jumpable(-1) ? \'<Plug>(vsnip-jump-prev)\' : \'<S-Tab>\'", opt },
        { "s", "<C-q>", "vsnip#expandable() ? \'<Plug>(vsnip-expand)\'    : \'<C-k>\'", opt },
        { "s", "<C-k>", "vsnip#jumpable(1)  ? \'<Plug>(vsnip-jump-next)\' : \'<Tab>\'", opt },
        { "s", "<C-j>", "vsnip#jumpable(-1) ? \'<Plug>(vsnip-jump-prev)\' : \'<S-Tab>\'", opt },
      })
    end,
  },

  -- Cmp
  {
    "hrsh7th/nvim-cmp",
    load = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-vsnip",
      "onsails/lspkind-nvim",
    },
    config = function()
      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      local cmp = require("cmp")
      local lk = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-f>"] = cmp.mapping.scroll_docs(-2),
          ["<C-d>"] = cmp.mapping.scroll_docs(2),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = false
          },
        }),
        sources = cmp.config.sources({
          {name = "nvim_lsp"},
          {name = "nvim_lua"},
          {name = "buffer", keyword_lenght = 5},
          {name = "path"},
          {name = "vsnip"},
        }),
        formatting = {
          format = lk.cmp_format({
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
   end,
  },

  -- Null-ls
  {
    "jose-elias-alvarez/null-ls.nvim", -- TODO: cofigure
    config = function() end,
  },
}
