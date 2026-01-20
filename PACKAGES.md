# Neovim Packages Overview

This document groups your plugin specs into clear packages organized in the `lua/plugins/` directory. Files are now physically organized into subfolders matching these categories for better maintainability.

## LSP & Languages (`lua/plugins/lang/`)

- [lua/plugins/lang/java.lua](lua/plugins/lang/java.lua): Java LSP (JDTLS), build/run tools, project generators, and utilities.
  - Includes: JDTLS server config, Spring Boot/Maven/Gradle support, dependency management, database migrations, and Java code templates
  - Java utilities: [lua/plugins/lang/java/](lua/plugins/lang/java/)
    - [java-utils.lua](lua/plugins/lang/java/java-utils.lua): Package detection, build tool detection, file utilities
    - [build-run.lua](lua/plugins/lang/java/build-run.lua): Spring Boot, Maven, and Gradle runners
    - [dependency-management.lua](lua/plugins/lang/java/dependency-management.lua): Dependency tree, vulnerability checks, updates
    - [profiles-management.lua](lua/plugins/lang/java/profiles-management.lua): Maven profiles and properties management
    - [migrations.lua](lua/plugins/lang/java/migrations.lua): Flyway migration helpers
    - [keymaps-java.lua](lua/plugins/lang/java/keymaps-java.lua): Java-specific keybindings (`<leader>j*`)
    - Templates: CRUD, Java files, and Spring Boot generators
- [lua/plugins/lang/mason.lua](lua/plugins/lang/mason.lua): Ensures core LSP/debug tools (jdtls, java-debug, java-test, stylua).
- [lua/plugins/lang/overrides.lua](lua/plugins/lang/overrides.lua): LSP/treesitter overrides (e.g., Angular root detection).
- [lua/plugins/lang/markdown.lua](lua/plugins/lang/markdown.lua): Markdown/MDX language tools.
- [lua/plugins/lang/obsidian.lua](lua/plugins/lang/obsidian.lua): Obsidian integration for notes/markdown.
- Built-ins via LazyVim imports: JSON, formatting, linting extras configured in [lua/config/lazy.lua](lua/config/lazy.lua).

## Debugging (`lua/plugins/debug/`)

- [lua/plugins/debug/nvim-dap.lua](lua/plugins/debug/nvim-dap.lua): Base DAP setup + Java debug defaults.

## AI & Assistants (`lua/plugins/ai/`)

- [lua/plugins/ai/copilot.lua](lua/plugins/ai/copilot.lua): GitHub Copilot base plugin.
- [lua/plugins/ai/copilot-chat.lua](lua/plugins/ai/copilot-chat.lua): Copilot Chat integration.
- [lua/plugins/ai/claude-code.lua](lua/plugins/ai/claude-code.lua): Anthropic-based coding assistant.
- [lua/plugins/ai/gemini.lua](lua/plugins/ai/gemini.lua): Google Gemini tooling.
- [lua/plugins/ai/code-companion.lua](lua/plugins/ai/code-companion.lua): Code Companion workflows.
- [lua/plugins/ai/avante.lua](lua/plugins/ai/avante.lua): AI-powered refactors/help.
- [lua/plugins/ai/codecompanion/codecompanion-notifier.lua](lua/plugins/ai/codecompanion/codecompanion-notifier.lua): Notifications for Code Companion.

## UI & Visuals (`lua/plugins/ui/`)

- [lua/plugins/ui/colorscheme.lua](lua/plugins/ui/colorscheme.lua): Colorschemes and theme selection.
- [lua/plugins/ui/ui.lua](lua/plugins/ui/ui.lua): UI tweaks and components.
- [lua/plugins/ui/twilight.lua](lua/plugins/ui/twilight.lua): Dim inactive code.
- [lua/plugins/ui/smear.lua](lua/plugins/ui/smear.lua): Cursor smear visuals.
- [lua/plugins/ui/precognition.lua](lua/plugins/ui/precognition.lua): Motion hints and guidance.
- [lua/plugins/ui/screenkey.lua](lua/plugins/ui/screenkey.lua): Show pressed keys on screen.

## Editing & Coding UX (`lua/plugins/editor/`)

- [lua/plugins/editor/editor.lua](lua/plugins/editor/editor.lua): Core editing enhancements.
- [lua/plugins/editor/which-key.lua](lua/plugins/editor/which-key.lua): Keybinding hints and groups.
- [lua/plugins/editor/multi-line.lua](lua/plugins/editor/multi-line.lua): Multi-line editing helpers.
- [lua/plugins/editor/vim-tmux-navigation.lua](lua/plugins/editor/vim-tmux-navigation.lua): Pane navigation with tmux.
- [lua/plugins/editor/blink.lua](lua/plugins/editor/blink.lua): Completion engine (Blink) and coding UX.

## Search, Files & Navigation (`lua/plugins/navigation/`)

- [lua/plugins/navigation/fzflua.lua](lua/plugins/navigation/fzflua.lua): FZF Lua finder.
- [lua/plugins/navigation/oil.lua](lua/plugins/navigation/oil.lua): File explorer in buffer.

## Utilities & Misc (`lua/plugins/utils/`)

- [lua/plugins/utils/opencode.lua](lua/plugins/utils/opencode.lua): Project helpers.
- [lua/plugins/utils/rip.lua](lua/plugins/utils/rip.lua): Ripgrep helpers.
- [lua/plugins/utils/vim-be-good.lua](lua/plugins/utils/vim-be-good.lua): Vim motions training.
- [lua/plugins/utils/disabled.lua](lua/plugins/utils/disabled.lua): Explicitly disabled plugins.

## Config Helper Modules

- [lua/config/lazy.lua](lua/config/lazy.lua): Lazy.nvim + LazyVim setup/imports.
- [lua/config/autocmds.lua](lua/config/autocmds.lua): Extra autocmds, including Java keymaps loader.
- [lua/config/keymaps.lua](lua/config/keymaps.lua): Global keymaps.
- [lua/config/options.lua](lua/config/options.lua): Global options.
- [lua/config/java-keymaps.lua](lua/config/java-keymaps.lua): Java/Spring/Quarkus commands and mappings.
- [lua/config/gentleman/java-utils.lua](lua/config/gentleman/java-utils.lua): Java-specific utility runners.
- [setup-jdtls.sh](setup-jdtls.sh): Headless installer/validator for JDTLS + Java tools.

Notes

- Import order and categories are for understanding; Lazy still imports specs from `lua/plugins` recursively via [lua/config/lazy.lua](lua/config/lazy.lua).
- If you want, we can physically move files into subfolders like `lua/plugins/{lsp,ai,ui,editor,tools,lang,debug}` — the current Lazy import supports nested dirs. I kept files in place to avoid churn; say the word and I’ll migrate them safely.
