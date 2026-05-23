return {
  "folke/twilight.nvim",
  opts = {
    dimming = {
      alpha = 0.35, -- Más sutil
      color = { "Normal", "#2A2331" }, -- Base wallust
      term_bg = "#2A2331",
      inactive = true,
    },
    context = 15, -- Más contexto visible
    treesitter = true,
    expand = {
      "function",
      "method",
      "table",
      "if_statement",
    },
  },
}
