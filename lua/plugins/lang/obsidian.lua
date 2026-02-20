return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- Siempre última release estable
  lazy = false,
  enabled = function()
    return not vim.g.disable_obsidian
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "work", -- O el nombre que vos quieras
        path = "/home/franqui/Documentos/work", -- Este ES tu directorio de trabajo real
      },
    },
    completion = {
      nvim_cmp = true, -- Si usás cmp, si no, ponelo false
    },
    picker = {
      name = "snacks.pick", -- Cambia a "telescope.nvim" si lo preferís
    },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },

    legacy_commands = true,
    notes_subdir = "hubs", -- Opcional, default es raíz del vault
    new_notes_location = "notes_subdir",
    callbacks = {
      enter_note = function(_, note)
        if not note or not note.bufnr then
          return
        end
        vim.keymap.set("n", "gf", function()
          return require("obsidian").util.gf_passthrough()
        end, { buffer = note.bufnr, expr = true, desc = "Obsidian follow link" })
        vim.keymap.set("n", "<leader>ch", function()
          return require("obsidian").util.toggle_checkbox()
        end, { buffer = note.bufnr, desc = "Toggle checkbox" })
        vim.keymap.set("n", "<cr>", function()
          return require("obsidian").util.smart_action()
        end, { buffer = note.bufnr, expr = true, desc = "Obsidian smart action" })
      end,
    },
  },
}
