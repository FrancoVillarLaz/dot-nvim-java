return {
  "coder/claudecode.nvim",
  dependencies = {
    { "folke/snacks.nvim" },
  },
  keys = {
    {
      "<leader>ac",
      "<cmd>ClaudeCode<cr>",
      desc = "Toggle Claude Code",
    },
    {
      "<leader>af",
      "<cmd>ClaudeCodeFocus<cr>",
      desc = "Focus Claude Code",
    },
    {
      "<leader>ar",
      "<cmd>ClaudeCode --resume<cr>",
      desc = "Resume Claude Code",
    },
    {
      "<leader>aC",
      "<cmd>ClaudeCode --continue<cr>",
      desc = "Continue Claude Code",
    },
    {
      "<leader>am",
      "<cmd>ClaudeCodeSelectModel<cr>",
      desc = "Claude Code select model",
    },
    {
      "<leader>aA",
      "<cmd>ClaudeCodeAdd %<cr>",
      desc = "Claude Code add buffer",
    },
    {
      "<leader>av",
      "<cmd>ClaudeCodeSend<cr>",
      mode = "v",
      desc = "Claude Code send selection",
    },
    {
      "<leader>ada",
      "<cmd>ClaudeCodeDiffAccept<cr>",
      desc = "Claude Code diff accept",
    },
    {
      "<leader>add",
      "<cmd>ClaudeCodeDiffDeny<cr>",
      desc = "Claude Code diff deny",
    },
  },
  config = true,
}
