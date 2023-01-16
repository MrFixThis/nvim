local tools = require("mrfixthis.tools").general
local report, mods = tools.secure_require({"jdtls", "jdtls.dap"})
if report then
  report(); return
end

local home = os.getenv("HOME")
local config = require("mrfixthis.lsp").makeConfig()
local root_markers = {".gradlew", ".mvnw", ".git",}
local root_dir = mods.jdtls.setup.find_root(root_markers)
local workspace_folder = string.format("%s/.local/share/eclipse/%s",
  home, vim.fn.fnamemodify(root_dir, ":p:h:t"))

--Capabilities
local extendedClientCapabilities = mods.jdtls.extendedClientCapabilities
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
    signatureHelp = {enabled = true},
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
  mods.jdtls.setup_dap({hotcodereplace = "auto"})
  mods.jdtls_dap.setup_dap_main_class_configs()
  mods.jdtls.setup.add_commands()

  local opt = {buffer = bufnr}
  tools.set_keymap({
    {"n", "<leader>or", mods.jdtls.organize_imports, opt},
    {"n", "<leader>am", mods.jdtls.extract_variable, opt},
    {"n", "<leader>om", mods.jdtls.extract_constant, opt},
    {"v", "<leader>am", "[[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]]", opt},
    {"v", "<leader>om", "[[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]]", opt},
    {"v", "<leader>dm", "[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]]", opt},

    --Test
    {"n", "<leader>tc", function()
        if vim.bo.modified then vim.cmd("w") end
        mods.jdtls.test_class()
      end,
    opt},
    {"n", "<leader>tn", function()
        if vim.bo.modified then vim.cmd("w") end
        mods.jdtls.test_nearest_method()
      end,
    opt},
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
mods.jdtls.start_or_attach(config)
