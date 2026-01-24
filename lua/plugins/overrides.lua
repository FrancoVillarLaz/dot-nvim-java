return {
  {
    -- Override Prettier config for Markdown (via conform.nvim used in LazyVim)
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        prettier = {
          prepend_args = { "--print-width", "80", "--prose-wrap", "always" },
        },
      },
    },
  },
}
