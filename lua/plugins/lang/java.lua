return {
  -- Asegurar que Mason instale JDTLS y herramientas de Java
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "jdtls", "java-debug-adapter", "java-test", "stylua" })
    end,
  },

  -- Configuración JDTLS - Java Language Server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {
          -- Detección de raíz del proyecto
          root_dir = require("lspconfig.util").root_pattern("pom.xml", "build.gradle", "settings.gradle"),

          -- Configuración del servidor
          settings = {
            java = {
              -- Soporte para frameworks modernos
              content_types = { "quarkus", "microprofile", "jakarta" },

              -- Directorio de workspace
              workspace = {
                name = require("lspconfig.util").root_pattern("pom.xml")(vim.loop.cwd()) or "default_java_ws",
                directory = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. (require("lspconfig.util").root_pattern("pom.xml")(vim.loop.cwd()) or "default"),
              },

              -- Configuración del JDK
              configuration = {
                runtimes = {
                  {
                    name = "JavaSE-21",
                    path = "/usr/lib/jvm/java-21-openjdk/",
                    default = true,
                  },
                },
              },

              -- Formato y configuración
              format = {
                enabled = true,
              },
            },
          },
        },
      },
    },
  },

  -- Setup de keymaps y utilidades de Java
  {
    dir = vim.fn.stdpath("config") .. "/lua/plugins/lang/java",
    name = "java-utils-setup",
    config = function()
      -- Cargar keymaps de Java
      require("plugins.lang.java.keymaps-java")
    end,
  },
}
