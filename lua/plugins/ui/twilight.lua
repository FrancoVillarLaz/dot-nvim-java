return {
  "folke/twilight.nvim",
  opts = {
    dimming = {
      alpha = 0.35, -- Más sutil
      color = { "Normal", "#2d3142" }, -- Color zen base
      term_bg = "#2d3142",
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
