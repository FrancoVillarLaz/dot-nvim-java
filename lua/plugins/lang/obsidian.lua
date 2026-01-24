return {
  "epwalsh/obsidian.nvim",
  version = "*",
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
        name = "work",
        path = "/home/franqui/Documentos/work",
        note_frontmatter_func = function(note)
          local aliases = {}
          if note.title then
            table.insert(aliases, note.title)
          end
          return {
            id = note.id,
            aliases = aliases,
            tags = {},
          }
        end,
      },
    },
    completion = { nvim_cmp = true },
    picker = { name = "snacks.pick" },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },
    note_id_func = function(title)
      local id = tostring(os.time())
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "_"):gsub("[^A-Za-z0-9_%-]", ""):lower()
        return id .. "-" .. suffix
      else
        return id
      end
    end,
    new_notes_location = function(title)
      if title and title:lower():match("david allen") then
        return { notes_subdir = "hubs/eficiencia/david_allen" }
      elseif title and title:lower():match("eficiencia") then
        return { notes_subdir = "hubs/eficiencia" }
      else
        return { notes_subdir = "inbox" }
      end
    end,
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
