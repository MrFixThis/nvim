--Jdtls setup
local HOME = os.getenv("HOME")
local capabilities = require("mrfixthis.lsp").capabilities
local jdtls = require("jdtls")
local root_markers = {"gradlew", "mvnw", ".git",}
local root_dir = jdtls.setup.find_root(root_markers)
-- Root dir config
local workspace_folder = string.format(
  "%s/.local/share/eclipse/%s", HOME, vim.fn.fnamemodify(root_dir, ":p:h:t")
)
local config = {}

--Capabilities
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.capabilities = capabilities

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
          path = "/opt/jdks/jdk-11.0.12/",
        },
        {
          name = "JavaSE-14",
          path = "/opt/jdks/jdk-14.0.2/"
        },
      }
    }
  }
}

--Cmd
config.cmd = {
  "/opt/jdks/jdk-14.0.2/bin/java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-Xms1g",
  "-jar", vim.fn.glob(HOME .. "/.local/servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
  "-configuration", HOME .. "/.local/servers/jdtls/config_linux",
  "-data", workspace_folder,
  "--add-modules=ALL-SYSTEM",
  "--add-opens", "java.base/java.util=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang=ALL-UNNAMED",
}
--Lombok support
local lombok_path = HOME .. "/.local/dev_tools/java/bundles/lombok/lombok.jar"
if vim.fn.filereadable(lombok_path) > 0 then
  table.insert(config.cmd, 2, string.format("-javaagent:%s", lombok_path))
end

--On-attach setup
config.on_attach = function()
  jdtls.setup_dap({hotcodereplace = "auto"})
  jdtls.setup.add_commands()
  require("jdtls.dap").setup_dap_main_class_configs() --temporary

  local set_keymap = require("mrfixthis.keymap").set_keymap
  local opt = {buffer = true}
  local jdtls_maps = {
    {"n", "<leader>or", jdtls.organize_imports, opt},
    {"n", "<leader>av", jdtls.test_class, opt},
    {"n", "<leader>tm", jdtls.test_nearest_method, opt},
    {"v", "<leader>am", function() jdtls.extract_variable(true) end, opt},
    {"n", "<leader>am", jdtls.extract_variable},
    {"n", "<leader>om", jdtls.extract_constant},
    {"v", "<leader>dm", function() jdtls.extract_method(true) end, opt},
  }

  set_keymap(jdtls_maps)
end

local bundles = {
  vim.fn.glob(
    HOME .. "/.local/dev_tools/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
  ),
}
vim.list_extend(
  bundles, vim.split(vim.fn.glob(HOME .. "/.local/dev_tools/vscode-java-test/server/*.jar"), "\n")
)

config.init_options = {
  bundles = bundles,
  extendedClientCapabilities = extendedClientCapabilities;
}

--Setup client
jdtls.start_or_attach(config)
