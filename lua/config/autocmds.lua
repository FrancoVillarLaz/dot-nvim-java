-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Cargar keymaps específicos para Java
require("plugins.lang.java.keymaps-java")

-- Solo muestra diagnostics de tipo ERROR o WARN (no hints ni info de estilo para ningún lenguaje)
vim.diagnostic.config({
  severity_sort = true,
  underline = {
    severity = {
      min = vim.diagnostic.severity.WARN,  -- solo WARNING en adelante
    },
  },
  virtual_text = {
    severity = {
      min = vim.diagnostic.severity.WARN,
    },
  },
  signs = {
    severity = {
      min = vim.diagnostic.severity.WARN,
    },
  },
  float = {
    severity_sort = true,
    severity = {
      min = vim.diagnostic.severity.WARN,
    },
  },
})
