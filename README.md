# 💻 NeoVim Configuration

Mi configuración personal de NeoVim optimizada para desarrollo full-stack con soporte especializado para Java, Spring Boot, Quarkus, TypeScript, JavaScript y más.

---

## ✨ Características Principales

- 🚀 **LSP Completo** - Autocompletado inteligente, diagnósticos y refactoring
- 🎨 **UI Moderna** - Interfaces limpias y productivas
- ⚡ **Rendimiento** - Lazy loading y configuración optimizada
- 🔧 **Java Enterprise** - Soporte completo para Spring Boot y Quarkus
- 🌐 **Web Development** - TypeScript, React, Node.js
- 🗄️ **Base de Datos** - Integración con Flyway y herramientas de migración
- 🤖 **AI Integrado** - Copilot, Claude, Gemini y más

---

## 📦 Instalación

### Requisitos Previos

```bash
# NeoVim 0.9+
sudo apt install neovim  # Ubuntu/Debian
brew install neovim      # macOS

# Node.js (para LSP servers)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs

# JDK 21 (para desarrollo Java)
sudo apt install openjdk-21-jdk

# Ripgrep (para búsquedas)
sudo apt install ripgrep

# Fd (para búsqueda de archivos)
sudo apt install fd-find
```

### Clonar Configuración

```bash
# Backup de configuración existente (si existe)
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# Clonar este repositorio
git clone https://github.com/tu-usuario/tu-repo.git ~/.config/nvim

# Iniciar NeoVim (instalará plugins automáticamente)
nvim
```

---

## 🎯 Uso Rápido

### Atajos Principales

| Atajo        | Acción                             |
| ------------ | ---------------------------------- |
| `<Space>`    | Leader key (prefijo para comandos) |
| `<leader>ff` | Buscar archivos                    |
| `<leader>fg` | Buscar en archivos (grep)          |
| `<leader>e`  | Explorador de archivos (Oil)       |
| `<leader>?`  | Ver todos los keymaps              |

### Navegación con Tmux

| Atajo         | Acción                               |
| ------------- | ------------------------------------ |
| `<C-h/j/k/l>` | Navegar entre paneles de Neovim/Tmux |
| `<C-\>`       | Último panel activo                  |
| `<C-Space>`   | Siguiente panel                      |

---

## 🔥 Características por Lenguaje

### Java / Spring Boot / Quarkus

Configuración completa para desarrollo enterprise Java. Ver [JAVA_SETUP.md](JAVA_SETUP.md) para documentación detallada.

**Atajos rápidos:**

- `<leader>ji` - Info del proyecto (framework, build tool)
- `<leader>jn` - Nuevo archivo Java
- `<leader>js` - Nuevo componente Spring Boot
- `<leader>jq` - Nuevo componente Quarkus
- `<leader>jg` - Generar CRUD completo
- `<leader>jrs` - Ejecutar Spring Boot

### TypeScript / JavaScript

- ✅ TSServer LSP con configuración optimizada
- ✅ Prettier
- ✅ Auto imports y organización
- ✅ React, Next.js, Node.js support

### Python

- ✅ Pyright LSP
- ✅ Black formatter
- ✅ DAP debugger

### Go

- ✅ gopls LSP
- ✅ gofmt / goimports
- ✅ Delve debugger

---

## 🧩 Plugins Principales

### Gestión y UI

- **lazy.nvim** - Gestor de plugins rápido y moderno
- **which-key** - Descubrimiento de keymaps
- **telescope** - Fuzzy finder
- **oil.nvim** - Explorador de archivos elegante
- **noice.nvim** - UI mejorada para mensajes

### LSP y Completado

- **nvim-lspconfig** - Configuración LSP
- **mason.nvim** - Gestor de LSP servers
- **blink.cmp** - Autocompletado rápido
- **nvim-jdtls** - Java Language Server

### AI y Productividad

- **copilot.lua** - GitHub Copilot
- **copilot-chat** - Chat con Copilot
- **avante.nvim** - Integración con Claude
- **codecompanion** - Asistente de código

### Git

- **lazygit** - UI de Git integrada
- **gitsigns** - Indicadores de cambios

### Debugging

- **nvim-dap** - Debug Adapter Protocol
- **nvim-dap-ui** - UI para debugging

---

## ⚙️ Estructura del Proyecto

```
~/.config/nvim/
├── init.lua                    # Punto de entrada
├── lazy-lock.json              # Lock de versiones de plugins
├── JAVA_SETUP.md              # Documentación de Java
├── README.md                   # Este archivo
├── lua/
│   ├── config/
│   │   ├── autocmds.lua       # Auto-comandos
│   │   ├── keymaps.lua        # Keymaps globales
│   │   ├── lazy.lua           # Configuración de lazy.nvim
│   │   ├── options.lua        # Opciones de NeoVim
│   │   └── util/              # Utilidades
│   └── plugins/
│       ├── ai/                # Plugins de IA
│       ├── debug/             # Debugging
│       ├── editor/            # Editores y UI
│       ├── lang/              # Configuración por lenguaje
│       │   └── java/         # Módulos Java completos
│       ├── navigation/        # Navegación y búsqueda
│       ├── ui/                # Temas y UI
│       └── utils/             # Utilidades generales
└── spell/                     # Diccionarios de spell check
```

---

## 🛠️ Personalización

### Agregar un Nuevo Plugin

Crea un archivo en `lua/plugins/`:

```lua
-- lua/plugins/mi-plugin.lua
return {
  "usuario/mi-plugin.nvim",
  config = function()
    require("mi-plugin").setup({
      -- opciones
    })
  end
}
```

### Agregar Keymaps Personalizados

Edita `lua/config/keymaps.lua`:

```lua
vim.keymap.set("n", "<leader>mp", function()
  print("Mi comando personalizado")
end, { desc = "Mi comando" })
```

### Cambiar Tema

Edita `lua/plugins/ui/colorscheme.lua` y cambia el colorscheme:

```lua
vim.cmd([[colorscheme catppuccin]])  -- o otro tema
```

---

## 📚 Recursos y Documentación

### Documentación Específica

- [Java Setup](JAVA_SETUP.md) - Configuración completa de Java
- [Package Management](PACKAGES.md) - Gestión de paquetes

### Enlaces Útiles

- [NeoVim Docs](https://neovim.io/doc/)
- [LazyVim](https://www.lazyvim.org/)
- [Mason Registry](https://mason-registry.dev/)

---

## 🐛 Troubleshooting

### LSP no funciona

```bash
# Verificar LSP instalado
:Mason

# Ver logs de LSP
:LspInfo
:LspLog

# Reiniciar LSP
:LspRestart
```

### Plugins no se cargan

```bash
# Limpiar y reinstalar
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
nvim
```

### Java JDTLS lento

```bash
# Limpiar workspace de JDTLS
rm -rf ~/.local/share/nvim/jdtls-workspace

# Aumentar memoria de Java
export JAVA_OPTS="-Xmx2g"
```

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas! Si tienes sugerencias o mejoras:

1. Fork el repositorio
2. Crea una branch para tu feature
3. Commit tus cambios
4. Push a la branch
5. Abre un Pull Request

---

## 📝 Notas

- Esta configuración está en constante evolución
- Algunos plugins pueden requerir dependencias adicionales
- Consulta la documentación específica de cada plugin para más detalles

---

## 📄 Licencia

MIT License - Ver [LICENSE](LICENSE) para más detalles

---

**Última actualización:** 22 de enero de 2026  
**NeoVim:** 0.9+  
**Mantenido por:** @tu-usuario
