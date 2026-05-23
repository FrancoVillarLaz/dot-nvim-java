return {
  {
    -- {
    --   "xiyaowong/transparent.nvim",
    --   config = function()
    --     require("transparent").setup({
    --       extra_groups = { -- table/string: additional groups that should be cleared
    --         "Normal",
    --         "NormalNC",
    --         "Comment",
    --         "Constant",
    --         "Special",
    --         "Identifier",
    --         "Statement",
    --         "PreProc",
    --         "Type",
    --         "Underlined",
    --         "Todo",
    --         "String",
    --         "Function",
    --         "Conditional",
    --         "Repeat",
    --         "Operator",
    --         "Structure",
    --         "LineNr",
    --         "NonText",
    --         "SignColumn",
    --         "CursorLineNr",
    --         "EndOfBuffer",
    --       },
    --       exclude_groups = {}, -- table: groups you don't want to clear
    --     })
    --   end,
    -- },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      opts = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true, -- disables setting the background color.
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      },
    },
    {
      "Gentleman-Programming/gentleman-kanagawa-blur",
      name = "gentleman-kanagawa-blur",
      priority = 1000,
    },
    {
      "Alan-TheGentleman/oldworld.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      "rebelot/kanagawa.nvim",
      priority = 1000,
      lazy = true,
      config = function()
        require("kanagawa").setup({
          compile = false, -- enable compiling the colorscheme
          undercurl = true, -- enable undercurls
          commentStyle = { italic = true },
          functionStyle = {},
          keywordStyle = { italic = true },
          statementStyle = { bold = true },
          typeStyle = {},
          transparent = true, -- do not set background color
          dimInactive = false, -- dim inactive window `:h hl-NormalNC`
          terminalColors = true, -- define vim.g.terminal_color_{0,17}
          colors = {
            palette = {
              -- Tussi wallust overrides: teñir kanagawa con acentos púrpura/magenta
              -- Mantenemos los colores funcionales (verde=string, azul=function)
              -- pero desplazamos violetas, rosas y fondos hacia wallust

              -- Keywords/statements: púrpura wallust en vez de oniViolet
              oniViolet = "#9A538C",
              -- Parameters: rosa claro wallust
              oniViolet2 = "#D1A9BD",
              -- Punctuation: gris rosado
              springViolet2 = "#927684",
              -- Special: magenta medio
              springViolet1 = "#864B68",
              -- Numbers: rosa fuerte wallust en vez de sakuraPink
              sakuraPink = "#B3648B",
              -- Comments: gris violeta (legible pero discreto)
              fujiGray = "#6B5A64",
              -- Line numbers / nontext
              sumiInk6 = "#514858",

              -- Backgrounds teñidos hacia wallust
              sumiInk0 = "#1E1926",
              sumiInk1 = "#211C2A",
              sumiInk2 = "#241F2D",
              sumiInk3 = "#2A2331",
              sumiInk4 = "#352E3D",
              sumiInk5 = "#413A4A",

              -- Popups/floats con tinte wallust
              waveBlue1 = "#2E2438",
              waveBlue2 = "#3D3148",

              -- Selection visual
              -- waveBlue1 se usa para bg_visual, ya teñido arriba
            },
            theme = {
              wave = {},
              lotus = {},
              dragon = {},
              all = {
                ui = {
                  bg_gutter = "none",
                  bg_sidebar = "none",
                  bg_float = "none",
                },
              },
            },
          },
          overrides = function(colors)
            local palette = colors.palette
            return {
              -- Transparencia
              LineNr = { bg = "none" },
              NormalFloat = { bg = "none" },
              FloatBorder = { bg = "none", fg = palette.springViolet1 },
              FloatTitle = { bg = "none", fg = palette.sakuraPink, bold = true },
              TelescopeNormal = { bg = "none" },
              TelescopeBorder = { bg = "none", fg = palette.springViolet1 },
              LspInfoBorder = { bg = "none" },

              -- CursorLine con tinte wallust sutil
              CursorLine = { bg = "#302839" },
              Visual = { bg = "#3D3148" },

              -- Matching brackets
              MatchParen = { fg = "#E4C9D6", bg = "#514858", bold = true },

              -- Indent guides sutiles
              IblIndent = { fg = "#352E3D" },
              IblScope = { fg = "#9A538C" },

              -- Git diff con tinte (mantener funcionalidad pero armonizar)
              DiffAdd = { bg = "#2B2E33" },
              DiffDelete = { bg = "#33242E" },
              DiffChange = { bg = "#2A2535" },

              -- Diagnostics: mantener colores funcionales pero suavizar
              DiagnosticVirtualTextHint = { fg = "#6A9589", bg = "none" },
              DiagnosticVirtualTextInfo = { fg = "#658594", bg = "none" },
              DiagnosticVirtualTextWarn = { fg = "#DCA561", bg = "none" },
              DiagnosticVirtualTextError = { fg = "#C34043", bg = "none" },

              -- Which-key
              WhichKeyFloat = { bg = "none" },
              WhichKeyBorder = { bg = "none", fg = palette.springViolet1 },

              -- Neo-tree
              NeoTreeNormal = { bg = "none" },
              NeoTreeNormalNC = { bg = "none" },
              NeoTreeRootName = { fg = palette.sakuraPink, bold = true },
              NeoTreeDirectoryIcon = { fg = palette.oniViolet },
              NeoTreeDirectoryName = { fg = palette.oniViolet2 },
              NeoTreeGitModified = { fg = palette.sakuraPink },

              -- Noice / cmdline
              NoiceCmdlinePopupBorder = { fg = palette.springViolet1, bg = "none" },

              -- Snacks
              SnacksNotifierBorderInfo = { fg = palette.springViolet1 },
            }
          end,
          theme = "wave", -- Load "wave" theme
          background = { -- map the value of 'background' option to a theme
            dark = "wave", -- try "dragon" !
            light = "lotus",
          },
        })
      end,
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "kanagawa",
      },
    },
  },
}
