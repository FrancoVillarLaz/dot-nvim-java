return {
  --------------------------------------------------
  -- Mason
  --------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "vtsls",
        "jdtls",
        "java-debug-adapter",
        "java-test",
      },
    },
  },

  --------------------------------------------------
  -- LSP
  --------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        --------------------------------------------------
        -- LUA
        --------------------------------------------------
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              diagnostics = {
                disable = { "assign-type-mismatch" },
              },
            },
          },
        },

        --------------------------------------------------
        -- TYPESCRIPT
        --------------------------------------------------
        vtsls = {},

        --------------------------------------------------
        -- JAVA (JDTLS)
        --------------------------------------------------
        jdtls = {
          settings = {
            java = {
              format = {
                enabled = true,
                settings = {
                  url = "file://" .. vim.fn.expand("~/.config/nvim/java-google-style.xml"),
                  profile = "GoogleStyle",
                },
              },
            },
          },
        },
      },
    },
  },
}
