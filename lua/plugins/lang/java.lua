return {
  -- Asegurar que Mason instale JDTLS y herramientas de Java
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "jdtls", "java-debug-adapter", "java-test" })
    end,
  },

  -- Plugin principal de JDTLS
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mason-org/mason.nvim" },
  },

  -- Configuración JDTLS
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Deshabilitar setup automático de jdtls ya que lo maneja nvim-jdtls
      setup = {
        jdtls = function()
          return true -- Prevenir setup automático
        end,
      },
      servers = {
        jdtls = {
          -- Configuración se maneja via nvim-jdtls
          keys = {},
        },
      },
    },
  },

  -- Setup de keymaps y utilidades de Java
  {
    dir = vim.fn.stdpath("config") .. "/lua/plugins/lang/java",
    name = "java-utils-setup",
    lazy = false,
    config = function()
      -- Cargar keymaps de Java cuando se abre archivo Java
      require("plugins.lang.java.keymaps-java")
    end,
  },
}
