-- Función de modo ZEN con símbolos elegantes
local mode = {
  "mode",
  fmt = function(s)
    local mode_map = {
      ["NORMAL"] = "◉", -- Zen círculo
      ["O-PENDING"] = "◉?", -- Zen con interrogación
      ["INSERT"] = "✎", -- Pluma zen
      ["VISUAL"] = "◈", -- Selección zen
      ["V-BLOCK"] = "▣", -- Bloque zen
      ["V-LINE"] = "▦", -- Línea zen
      ["V-REPLACE"] = "⟲", -- Reemplazo zen
      ["REPLACE"] = "⟲", -- Reemplazo zen
      ["COMMAND"] = "⌘", -- Comando zen
      ["SHELL"] = "⬢", -- Shell zen
      ["TERMINAL"] = "⬢", -- Terminal zen
      ["EX"] = "⌘", -- Ex zen
      ["S-BLOCK"] = "▣", -- Select block zen
      ["S-LINE"] = "▦", -- Select line zen
      ["SELECT"] = "◈", -- Select zen
      ["CONFIRM"] = "✓", -- Confirmar zen
      ["MORE"] = "…", -- Más zen
    }
    return mode_map[s] or "●"
  end,
}

local function codecompanion_adapter_name()
  local chat = require("codecompanion").buf_get_chat(vim.api.nvim_get_current_buf())
  if not chat then
    return nil
  end

  return " " .. chat.adapter.formatted_name
end

local function codecompanion_current_model_name()
  local chat = require("codecompanion").buf_get_chat(vim.api.nvim_get_current_buf())
  if not chat then
    return nil
  end

  return chat.settings.model
end

-- This file contains the configuration for various UI-related plugins in Neovim.
return {
  -- Plugin: folke/todo-comments.nvim
  -- URL: https://github.com/folke/todo-comments.nvim
  -- Description: Plugin to highlight and search for TODO, FIX, HACK, etc. comments in your code.
  -- IMPORTANT: using version "*" to fix a bug
  {
    "folke/todo-comments.nvim",
    version = "*",
    opts = {
      signs = false, -- Sin signos en gutter para ser más zen
      highlight = {
        keyword = "bg", -- Menos agresivo
        after = "", -- Sin texto después para minimalismo
      },
      colors = {
        error = { "#B3648B" }, -- Rosa fuerte wallust
        warning = { "#864B68" }, -- Magenta medio wallust
        info = { "#9A538C" }, -- Púrpura wallust
        hint = { "#D1A9BD" }, -- Rosa claro wallust
        default = { "#927684" }, -- Gris rosado wallust
      },
    },
  },

  -- Plugin: folke/which-key.nvim
  -- URL: https://github.com/folke/which-key.nvim
  -- Description: Plugin to show a popup with available keybindings.
  -- IMPORTANT: using event "VeryLazy" to optimize loading time
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern", -- Más limpio que classic
      win = {
        border = "none", -- Sin bordes para zen
        padding = { 2, 2 }, -- Más espaciado zen
      },
      layout = {
        spacing = 6, -- Más espaciado zen
      },
      icons = {
        breadcrumb = "»", -- separador zen
        separator = "➜", -- separador zen
        group = "+",
      },
    },
  },

  -- Plugin: nvim-docs-view
  -- URL: https://github.com/amrbashir/nvim-docs-view
  -- Description: A Neovim plugin for viewing documentation.
  {
    "amrbashir/nvim-docs-view",
    lazy = true, -- Load this plugin lazily
    cmd = "DocsViewToggle", -- Command to toggle the documentation view
    opts = {
      position = "right", -- Position the documentation view on the right
      width = 50, -- Más angosto para menos distracción zen
      height = 20,
      update_mode = "auto",
    },
  },

  -- Plugin: lualine.nvim
  -- URL: https://github.com/nvim-lualine/lualine.nvim
  -- Description: A blazing fast and easy to configure Neovim statusline plugin.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy", -- Load this plugin on the 'VeryLazy' event
    requires = { "nvim-tree/nvim-web-devicons", opt = true }, -- Optional dependency for icons
    opts = {
      options = {
        theme = {
          normal = {
            a = { fg = "#2A2331", bg = "#9A538C", gui = "bold" },
            b = { fg = "#D1A9BD", bg = "#514858" },
            c = { fg = "#927684", bg = "NONE" },
          },
          insert = {
            a = { fg = "#2A2331", bg = "#B3648B", gui = "bold" },
          },
          visual = {
            a = { fg = "#2A2331", bg = "#864B68", gui = "bold" },
          },
          replace = {
            a = { fg = "#2A2331", bg = "#723E69", gui = "bold" },
          },
          command = {
            a = { fg = "#2A2331", bg = "#D1A9BD", gui = "bold" },
          },
          inactive = {
            a = { fg = "#927684", bg = "NONE" },
            b = { fg = "#927684", bg = "NONE" },
            c = { fg = "#514858", bg = "NONE" },
          },
        },
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { mode }, -- Símbolo zen del modo
        lualine_b = {}, -- Vacío para minimalismo
        lualine_c = {
          {
            "filename",
            path = 0, -- Solo nombre del archivo
            symbols = {
              modified = " ●", -- Punto zen para modificado
              readonly = " ◉", -- Círculo zen para readonly
              unnamed = "◯", -- Círculo vacío zen
            },
          },
        },
        lualine_x = {}, -- Vacío para zen
        lualine_y = {}, -- Vacío para zen
        lualine_z = {
          {
            "location",
            fmt = function(str)
              return str:gsub(":", "·") -- Separador zen
            end,
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            symbols = { modified = " ●", readonly = " ◉" },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        "quickfix",
        {
          filetypes = { "oil" },
          sections = {
            lualine_a = { mode },
            lualine_b = {
              function()
                local ok, oil = pcall(require, "oil")
                if not ok then
                  return ""
                end

                ---@diagnostic disable-next-line: param-type-mismatch
                local path = vim.fn.fnamemodify(oil.get_current_dir(), ":~")
                return path .. " %m"
              end,
            },
          },
        },
        {
          filetypes = { "codecompanion" },
          sections = {
            lualine_a = { mode },
            lualine_b = { codecompanion_adapter_name },
            lualine_c = { codecompanion_current_model_name },
            lualine_x = {},
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = { codecompanion_adapter_name },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { "progress" },
            lualine_z = {},
          },
        },
      },
    },
  },

  -- Plugin: incline.nvim
  -- URL: https://github.com/b0o/incline.nvim
  -- Description: A Neovim plugin for showing the current filename in a floating window.
  {
    "b0o/incline.nvim",
    event = "BufReadPre", -- Load this plugin before reading a buffer
    priority = 1200, -- Set the priority for loading this plugin
    config = function()
      require("incline").setup({
        window = {
          margin = { vertical = 0, horizontal = 2 }, -- Más margen horizontal zen
          padding = { left = 1, right = 1 },
          zindex = 10,
        },
        hide = {
          cursorline = true, -- Hide the incline window when the cursorline is active
          focused_win = false,
          only_win = true, -- Ocultar si es la única ventana zen
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t") -- Get the filename
          if vim.bo[props.buf].modified then
            filename = "● " .. filename -- Punto zen para modificado
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename) -- Get the icon and color for the file
          return {
            { icon, guifg = color or "#9A538C" }, -- Magenta wallust
            { " " },
            { filename, guifg = "#D1A9BD" }, -- Texto wallust
          }
        end,
      })
    end,
  },

  -- Plugin: zen-mode.nvim
  -- URL: https://github.com/folke/zen-mode.nvim
  -- Description: A Neovim plugin for distraction-free coding.
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode", -- Command to toggle Zen Mode
    opts = {
      window = {
        backdrop = 0.95,
        width = 0.8, -- Un poco más ancho
        height = 0.9,
        options = {
          signcolumn = "no", -- Sin columna de signos zen
          number = false, -- Sin números de línea zen
          relativenumber = false,
          cursorline = false, -- Sin highlight de línea zen
          cursorcolumn = false,
          foldcolumn = "0",
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0, -- Sin statusline en zen
        },
        gitsigns = { enabled = false }, -- Sin gitsigns en zen mode
        tmux = { enabled = true }, -- Enable tmux integration
        twilight = { enabled = true }, -- Enable twilight integration
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } }, -- Keybinding to toggle Zen Mode
  },

  -- Plugin: snacks.nvim
  -- URL: https://github.com/folke/snacks.nvim/tree/main
  -- Description: A Neovim plugin for creating a customizable dashboard.
  {
    "folke/snacks.nvim",
    priority = 1000, -- Carga después de LazyVim para que nuestra config prevalezca
    keys = {
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Find Buffers",
      },
    },
    opts = {
      notifier = {
        enabled = true,
        origin = "top_left",
        margin = { top = 1, right = 0, bottom = 0, left = 2 },
      },
      image = {},
      picker = {
        exclude = {
          ".git",
          "node_modules",
        },
        matcher = {
          fuzzy = true,
          smartcase = true,
          ignorecase = true,
          filename_bonus = true,
        },
        sources = {
          -- explorer = {
          --   matcher = {
          --     fuzzy = true, -- Enables fuzzy matching, so you can be a bit imprecise with your search terms
          --     smartcase = true, -- If your search term has uppercase letters, the search becomes case-sensitive
          --     ignorecase = true, -- Ignores case when searching, unless smartcase is triggered
          --     filename_bonus = true, -- Gives a higher priority to matches in filenames
          --     sort_empty = false, -- If no matches are found, it won't sort the results
          --   },
          -- },
        },
      },
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Actions", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
        preset = {
          header = [[
       _________________________________________________________________________________
      /                                                                                 \
      | ███████╗██████╗  █████╗ ███╗   ██╗ ██████╗ ██╗   ██╗██╗      ██╗   ██╗██╗███╗   ███╗|
      | ██╔════╝██╔══██╗██╔══██╗████╗  ██║██╔═══██╗██║   ██║██║      ██║   ██║██║████╗ ████║|
      | █████╗  ██████╔╝███████║██╔██╗ ██║██║   ██║██║   ██║██║█████╗██║   ██║██║██╔████╔██║|
      | ██╔══╝  ██╔══██╗██╔══██║██║╚██╗██║██║▄▄ ██║██║   ██║██║╚════╝╚██╗ ██╔╝██║██║╚██╔╝██║|
       | ██║     ██║  ██║██║  ██║██║ ╚████║╚██████╔╝╚██████╔╝██║       ╚████╔╝ ██║██║ ╚═╝ ██║|
      | ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚══▀▀═╝  ╚═════╝ ╚═╝        ╚═══╝  ╚═╝╚═╝     ╚═╝|
      \_________________________________________________________________________________/
        ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = "🧘", key = "z", desc = "Zen Mode", action = ":ZenMode" }, -- Agregado zen
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },

  -- Plugin: nvim-neo-tree/neo-tree.nvim
  -- Description: Neo-tree sidebar file manager positioned right.
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      window = {
        position = "right", -- Cambio a izquierda para mejor flujo zen
        width = 35, -- Más angosto zen
      },
      default_component_configs = {
        indent = {
          with_expanders = false, -- Sin expandir para simplicidad zen
          expander_collapsed = "▸",
          expander_expanded = "▾",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
        },
        modified = { symbol = "●" }, -- Símbolo zen para modificado
        git_status = {
          symbols = {
            added = "✚",
            deleted = "✖",
            modified = "●", -- Zen
            renamed = "➜", -- Zen
            untracked = "★",
            ignored = "◌", -- Zen
            unstaged = "✗",
            staged = "✓", -- Zen
            conflict = "",
          },
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
}
