local set_keymap = require("utils").set_keymap

-- Global build of clients' capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities(
  vim.lsp.protocol.make_client_capabilities())

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

return {
  --Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
        width = 0.9,
        height = 0.9,
      },
      ensure_installed = {
        "debugpy", "node-debug2-adapter", "java-test", "java-debug-adapter",
        "jdtls", "css-lsp", "html-lsp",  "gopls", "json-lsp", "lua-language-server",
        "shfmt", "stylua", "taplo", "typescript-language-server", "vim-language-server",
        "yaml-language-server", "sqlfluff", "dockerfile-language-server",
        "docker-compose-language-service"
      },
    },
    config = function(_, opts)
      -- Helper to install tools via `ensure_installed` key
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local pack = mr.get_package(tool)
        if not pack:is_installed() then
          pack:install()
        end
      end
    end,
  },

  -- Null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        border = "rounded",
        debounce = 100,
        save_after_format = false,
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.zsh,
          nls.builtins.diagnostics.sqlfluff.with({
            extra_args = { "--dialect", "mysql" },
          })
        },
      }
    end,
  },

  --Lsp
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
    },
    opts = {
      autoformat = true,
      diagnostics = {
        underline = true,
        severity_sort = true,
      },
      servers = {
        -- Default
        pylsp = {},
        tsserver = {},
        cssls = {},
        yamlls = {},
        vimls = {},
        taplo = {},
        jsonls = {},
        dockerls = {},
        docker_compose_language_service = {},

        -- Lua
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";")
              },
              workspace = { checkThirdParty = false, },
              diagnostics = {
                globals = { "vim" },
                unusedLocalExclude = { "_*" },
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              semantic = { enable = false },
            },
          },
        },

        -- Go
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

        -- Html
        html = { filetypes = { "html", "jsp" } },
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
          callback = function(args)
            local bufnr = args.buf
            local buf = { buffer = bufnr }
            set_keymap({
              { "n", "gD", vim.lsp.buf.declaration, buf },
              { "n", "<leader>du", vim.lsp.buf.definition, buf },
              { "n", "<leader>re", vim.lsp.buf.references, buf },
              { "n", "<leader>vi", vim.lsp.buf.implementation, buf },
              { "n", "<leader>sh", vim.lsp.buf.signature_help, buf },
              { "n", "<leader>gt", vim.lsp.buf.type_definition, buf},
              { "n", "<leader>gw", vim.lsp.buf.document_symbol, buf},
              { "n", "<leader>gW", vim.lsp.buf.workspace_symbol, buf},
              --Actions mappings
              { "n", "<leader>ah", vim.lsp.buf.hover, buf },
              { "n", "<leader>ca", vim.lsp.buf.code_action, buf },
              { "n", "<leader>rn", vim.lsp.buf.rename, buf },
              -- Few language severs support these three
              { "n", "<leader>=", function() vim.lsp.buf.format({ async = true }) end, buf },
              { "n", "<leader>ai", vim.lsp.buf.incoming_calls, buf },
              { "n", "<leader>ao", vim.lsp.buf.outgoing_calls, buf },
              --Diagnostics mappings
              { "n", "<leader>ee", vim.diagnostic.open_float, buf },
              { "n", "<leader>gp", vim.diagnostic.goto_prev, buf },
              { "n", "<leader>gn", vim.diagnostic.goto_next, buf },
              --Custom
              { "n", "<leader>~", "<CMD>LspRestart<CR>", buf },
            })
          end,
      })

      -- Diagnostics
      local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      -- Floating preview window's borders
      local original_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = "rounded" -- to force the rounded in everything
        return original_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- Setup servers
      local servers = opts.servers
      local setup_server = function(server)
        local server_opts = vim.tbl_deep_extend("force",
          {
            capabilities = vim.deepcopy(capabilities),
            flags = {
              debounce_text_changes = nil,
            },
          }, servers[server] or {})
          require("lspconfig")[server].setup(server_opts)
      end

      require("mason-lspconfig").setup()
      for server, _ in pairs(servers) do setup_server(server) end
      require("neodev").setup()
    end,
  },

  -- Rust tools
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      local rt = require("rust-tools")
      local exec = require("rust-tools.executors")

      rt.setup({
        server = {
          capabilities = vim.deepcopy(capabilities),
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "self",
          },
          cargo = {
            allFeatures = true,
            buildScripts = {
              enable = true,
            },
          },
          procMacro = { enable = true },
          on_attach = function(_, bufnr)
            local opts = { buffer = bufnr }
            set_keymap({
              { "n", "<leader>cr", rt.runnables.runnables, opts },
              { "n", "<leader>cd", rt.debuggables.debuggables, opts },
              { "n", "<leader>ct", rt.open_cargo_toml.open_cargo_toml, opts },
              { "n", "<leader>cs", rt.standalone.start_standalone_client, opts },
              { "n", "<leader>cc", rt.workspace_refresh.reload_workspace, opts },
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
          executor = exec.toggleterm,
          inlay_hints = { auto = false, },
        },
      })
    end,
  },

  -- Nvim-jdtls
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local home = os.getenv("HOME")
      local jdtls = require("jdtls")
      local root_markers = { ".gradlew", ".mvnw", ".git", }
      local root_dir = jdtls.setup.find_root(root_markers)
      local workspace_folder = string.format("%s/.local/share/eclipse/%s",
        home, vim.fn.fnamemodify(root_dir, ":p:h:t"))

      -- Extended capabilities
      local extendedClientCapabilities = jdtls.extendedClientCapabilities
      extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

      local msn_path = vim.fn.stdpath("data") .. "/mason/packages/"
      local bundles = {
        vim.fn.glob(
          msn_path .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
        )
      }
      vim.list_extend(
        bundles,
        vim.split(vim.fn.glob(msn_path .. "java-test/extension/server/*.jar"), "\n"))

      local config = {
        init_options = {
          bundles = bundles,
          extendedClientCapabilities = extendedClientCapabilities
        },
        capabilities = vim.deepcopy(capabilities),
        flags = { debounce_text_changes = 100, },
        handlers = { ["language/status"] = function() end, },
        cmd = {
          "/opt/jdks/jdk-17.0.4.1/bin/java",
          "-javaagent:" .. msn_path .. "jdtls/lombok.jar",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xmx1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-jar", vim.fn.glob(msn_path .. "jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration", msn_path .. "jdtls/config_linux",
          "-data", workspace_folder,
        },
        settings = {
          java = {
            signatureHelp = { enabled = true },
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
        },
        on_attach = function(_, bufnr)
          jdtls.setup_dap({ hotcodereplace = "auto" })
          jdtls.setup.add_commands()

          local opt = { buffer = bufnr }
          set_keymap({
            { "n", "<leader>or", jdtls.organize_imports, opt },
            { "n", "<leader>am", jdtls.extract_variable, opt },
            { "n", "<leader>om", jdtls.extract_constant, opt },
            { "v", "<leader>am", "[[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]]", opt },
            { "v", "<leader>om", "[[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]]", opt },
            { "v", "<leader>dm", "[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]]", opt },
            -- Testing
            {
              "n", "<leader>tc", function()
                if vim.bo.modified then vim.cmd("w") end
                jdtls.test_class()
              end, opt
            },
            {
              "n", "<leader>tn", function()
                if vim.bo.modified then vim.cmd("w") end
                jdtls.test_nearest_method()
              end, opt
            },
          })
        end,
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = "*.java",
        callback = function() jdtls.start_or_attach(config) end,
      })

      jdtls.start_or_attach(config)
    end
  },
}
