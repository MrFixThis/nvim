--Jdtls setup
local home = os.getenv("HOME")
local set_keymap = require("mrfixthis.keymap").set_keymap
local capabilities = require("mrfixthis.lsp").capabilities
local jdtls = require("jdtls")
local root_markers = {".gradlew", ".mvnw", ".git",}
local root_dir = jdtls.setup.find_root(root_markers)
local workspace_folder = string.format("%s/.local/share/eclipse/%s",
  home, vim.fn.fnamemodify(root_dir, ":p:h:t"))
local config = {}

--Capabilities
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.capabilities = capabilities

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
      }
    }
  }
}

--On-attach setup
config.on_attach = function(_, bufnr)
  jdtls.setup_dap({hotcodereplace = "auto"})
  jdtls.setup.add_commands()
  require("jdtls.dap").setup_dap_main_class_configs() --temporary

  local opt = {buffer = bufnr}
  local jdtls_mappings = {
    {"n", "<leader>or", jdtls.organize_imports, opt},
    {"n", "<leader>am", jdtls.extract_variable, opt},
    {"n", "<leader>om", jdtls.extract_constant, opt},
    {"v", "<leader>am", "[[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]]", opt},
    {"v", "<leader>om", "[[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]]", opt},
    {"v", "<leader>dm", "[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]]", opt},

    --Test
    {"n", "<leader>tc", function()
        if vim.bo.modified then vim.cmd("w") end
        jdtls.test_class()
      end,
    opt},
    {"n", "<leader>tn", function()
        if vim.bo.modified then vim.cmd("w") end
        jdtls.test_nearest_method()
      end,
    opt},
  }

  set_keymap(jdtls_mappings)
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

--Setup client
jdtls.start_or_attach(config)
