# 🚀 Java Development Setup - NeoVim Configuration Guide

Complete guide to the Java development environment configured in this NeoVim setup. This configuration provides powerful tools for Java, Spring Boot, Quarkus, and Maven/Gradle projects.

---

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Language Server (JDTLS)](#language-server-jdtls)
3. [Keybindings](#keybindings)
4. [Build & Run Tools](#build--run-tools)
5. [Code Generators](#code-generators)
6. [Dependency Management](#dependency-management)
7. [Database Migrations](#database-migrations)
8. [Maven Profiles](#maven-profiles)
9. [Tips & Tricks](#tips--tricks)
10. [Configuration Files](#configuration-files)

---

## Quick Start

### Opening a Java Project

```bash
nvim <path-to-java-project>
```

### Automatic Setup

When you open a `.java` file, the following happens automatically:

- **JDTLS** (Java Language Server) starts
- **Java keybindings** are loaded (`<leader>j*`)
- **Project type** is detected (Maven, Gradle, Spring Boot, Quarkus)
- **LSP features** become available (completion, diagnostics, etc.)

### First Command

Press `<leader>ji` to see detected project type and framework.

---

## Language Server (JDTLS)

### About JDTLS

**JDTLS** is the Eclipse Java Language Server providing:

- ✅ **Code Completion** - IntelliSense-style suggestions
- ✅ **Go to Definition** - Jump to class/method definitions
- ✅ **Hover Information** - View type info and documentation
- ✅ **Diagnostics** - Real-time error and warning detection
- ✅ **Refactoring** - Rename, extract methods, organize imports
- ✅ **Code Navigation** - Find references, implementations
- ✅ **Treesitter Support** - Modern syntax highlighting

### Configuration Details

**Location:** `lua/plugins/lang/java.lua`

**Features:**

- Auto-detection of project root (pom.xml, build.gradle)
- JDK 21 runtime (OpenJDK)
- Workspace directory: `~/.local/share/nvim/jdtls-workspace/`
- Support for Quarkus, Microprofile, Jakarta frameworks

### Troubleshooting LSP

If JDTLS doesn't start:

1. Check project has `pom.xml` or `build.gradle`
2. Verify JDK is installed: `java -version`
3. Restart Neovim
4. Check Mason installed jdtls: `:Mason`

---

## Keybindings

All Java keybindings start with `<leader>j`. Use `<leader>?` to see all available mappings.

### General

| Binding      | Action            | Notes                                    |
| ------------ | ----------------- | ---------------------------------------- |
| `<leader>ji` | Show project info | Framework, Build Tool, Package detection |
| `<leader>jc` | Open config file  | Opens application.properties/yml         |
| `<leader>?`  | Show all keymaps  | Uses which-key plugin                    |

---

## Build & Run Tools

### Spring Boot Projects

| Binding       | Command          | Purpose                                             |
| ------------- | ---------------- | --------------------------------------------------- |
| `<leader>jrs` | Run Spring Boot  | Starts `mvn spring-boot:run` or `./gradlew bootRun` |
| `<leader>jrp` | Run with Profile | Runs with specific Maven profile                    |

**Example Usage:**

```bash
# Open a Spring Boot project
nvim src/main/java/Application.java

# Press <leader>jrs to start the application
# Output appears in terminal (splits window or runs in background)
```

### Maven Build

| Binding       | Command     | Purpose                  |
| ------------- | ----------- | ------------------------ |
| `<leader>jrm` | Maven Build | Runs `mvn clean package` |

### Gradle Build

| Binding       | Command      | Purpose                |
| ------------- | ------------ | ---------------------- |
| `<leader>jrg` | Gradle Build | Runs `./gradlew build` |

---

## Code Generators

### Java File Generator

| Binding      | Action                  |
| ------------ | ----------------------- |
| `<leader>jn` | Generate new Java class |

**Features:**

- Automatic package detection from directory structure
- Class, Interface, Enum, Record, Abstract Class generation
- Constructor generation

**Types available:**

- Class
- Interface
- Enum
- Record
- Abstract Class

**Example:**

```bash
# In src/main/java/com/example/model/
nvim UserModel.java
<leader>jn  # Opens generator with correct package

# Choose options:
# - Class type (Class, Interface, Enum, etc.)
# - Enter name
# - File is created with correct package
```

### Spring Boot Generator

| Binding      | Action                         |
| ------------ | ------------------------------ |
| `<leader>js` | Generate Spring Boot component |

**Types available:**

- `Controller` - REST Controller
- `Service` - Business logic service
- `Repository` - JPA Repository
- `Entity` - JPA entity
- `DTO Request` - Request DTO record
- `DTO Response` - Response DTO record
- `Mapper` - Mapper interface
- `Config` - Spring configuration class
- `Exception` - Custom exception
- `Exception Handler` - Global exception handler

**Example:**

```bash
<leader>js
# Choose: Service
# Name: User
# Auto-generates UserService.java with Spring @Service annotation
```

### Quarkus Generator

| Binding      | Action                     |
| ------------ | -------------------------- |
| `<leader>jq` | Generate Quarkus component |

**Types available:**

- `Controller` - JAX-RS Resource (REST endpoint)
- `Service` - Business logic service (@ApplicationScoped)
- `Repository` - Panache Repository
- `Entity` - Panache Entity
- `DTO Request` - Request DTO record
- `DTO Response` - Response DTO record
- `Mapper` - Mapper interface
- `Config` - Configuration bean
- `Exception` - Custom exception
- `Exception Handler` - Exception mapper

**Example:**

```bash
<leader>jq
# Choose: Controller
# Name: User
# Auto-generates UserResource.java with JAX-RS annotations
```

### CRUD Generator

| Binding      | Action                   |
| ------------ | ------------------------ |
| `<leader>jg` | Generate CRUD operations |

**Generates:**

- JPA Entity class
- Repository (Spring Data or Panache)
- Service class (CRUD operations)
- REST Controller/Resource with endpoints

**Framework Detection:**

- Automatically detects Spring Boot or Quarkus
- Generates appropriate annotations and code style
- Supports Maven and Gradle projects

**Example:**

```bash
# In a Spring Boot or Quarkus project
<leader>jg
# Name: Product
# Generates complete CRUD stack for Product entity
```

### Getters/Setters Generator

| Binding       | Action                   |
| ------------- | ------------------------ |
| `<leader>jgg` | Generate Getters/Setters |

**Features:**

- Detects all fields in current class
- Generates getters and setters
- Smart insertion at end of class

---

## Dependency Management

### Add Dependency

| Binding       | Action             |
| ------------- | ------------------ |
| `<leader>jda` | Add new dependency |

**Interactive:**

- Choose: Maven or Gradle
- Search for dependency (e.g., "spring-boot-starter-web")
- Select version
- Auto-adds to `pom.xml` or `build.gradle`

**Example:**

```bash
<leader>jda
# Search: spring-boot
# Select: spring-boot-starter-web v3.x.x
# Dependency added and dependencies installed
```

### View Dependency Tree

| Binding       | Action               |
| ------------- | -------------------- |
| `<leader>jdt` | Show dependency tree |

**Shows:**

- All dependencies (direct and transitive)
- Versions
- Conflicts and duplicates
- Tree structure

### Update Dependencies

| Binding       | Action                        |
| ------------- | ----------------------------- |
| `<leader>jdu` | Check and update dependencies |

**Features:**

- Lists available updates
- Safe version constraints
- Updates `pom.xml` or `build.gradle`

### Security Check

| Binding       | Action                    |
| ------------- | ------------------------- |
| `<leader>jdv` | Check for vulnerabilities |

**Checks:**

- Known security vulnerabilities
- Uses OWASP databases
- Shows severity levels
- Recommends patches

**Example Output:**

```
Vulnerability Report
=====================
WARNING: log4j-core 2.0 - RCE vulnerability (CVE-2021-44228)
RECOMMENDATION: Upgrade to 2.17.0 or higher
```

---

## Database Migrations

### Flyway Integration

| Binding       | Action                |
| ------------- | --------------------- |
| `<leader>jbr` | Run Flyway migrations |
| `<leader>jbn` | Create new migration  |

### Create Migration

**Workflow:**

```bash
<leader>jbn
# Enter migration description: "CreateUsersTable"
# Generates: V1__CreateUsersTable.sql
# Opens file in editor
# Write SQL:
#   CREATE TABLE users (
#     id BIGINT PRIMARY KEY,
#     name VARCHAR(100) NOT NULL
#   );
# Save and run <leader>jbr
```

### Run Migrations

```bash
<leader>jbr
# Runs all pending migrations
# Shows: Applied migrations and status
```

**Features:**

- Auto-version detection
- Validation of migration scripts
- Rollback support
- Baseline detection

---

## Maven Profiles

### Switch Profile

| Binding       | Action               |
| ------------- | -------------------- |
| `<leader>jps` | Switch Maven profile |

**Example Profiles:**

- `dev` - Local development
- `test` - Testing environment
- `prod` - Production settings

### Manage Profiles

| Binding       | Action                        |
| ------------- | ----------------------------- |
| `<leader>jpn` | Create new profile            |
| `<leader>jpe` | Edit `application.properties` |
| `<leader>jpp` | Edit profile properties       |
| `<leader>jpi` | View profile info             |

**Example Usage:**

```bash
<leader>jps
# Select: test profile
# Spring Boot now runs with test configuration

<leader>jpe
# Opens: src/main/resources/application.properties
# Edit database, logging, etc.
```

---

## Tips & Tricks

### Quick Navigation

1. **Go to Definition:** `gd` (LSP)
2. **Find References:** `gr` (LSP)
3. **Show Hover:** `K` (LSP)
4. **Diagnostics:** `<leader>e` (LazyVim default)

### Code Completion

- Triggered automatically by JDTLS
- Scroll with `<C-n>` / `<C-p>`
- Accept with `<Tab>` or `<C-y>`
- Dismiss with `<Esc>`

### Refactoring

- **Rename:** Cursor on symbol → `<leader>lr` (LSP rename)
- **Extract:** Select code → `:LspCodeAction` → choose extract

### Performance Tips

1. **Large Projects:** JDTLS may take 10-30 seconds to index
2. **Memory:** Set environment variable before opening Neovim:
   ```bash
   export JAVA_OPTS="-Xmx2g"
   nvim <project>
   ```
3. **Workspace:** JDTLS caches in `~/.local/share/nvim/jdtls-workspace/`

### Common Issues

**Issue:** JDTLS slow on first open

- **Solution:** Be patient (30s), subsequent opens are instant

**Issue:** Completion not working

- **Solution:** Verify project structure has `pom.xml` or `build.gradle`

**Issue:** Wrong package detected

- **Solution:** File must be in correct directory: `src/main/java/com/example/User.java`

---

## Configuration Files

### File Locations

```
~/.config/nvim/
├── lua/
│   ├── config/
│   │   ├── util/java-utils.lua            # Utility functions
│   │   └── autocmds.lua                   # Auto-loading Java keymaps
│   └── plugins/
│       └── lang/
│           ├── lsp.lua                    # Main JDTLS config
│           ├── mason.lua                  # Tool installation
│           └── java/
│               ├── keymaps-java.lua       # All Java keybindings
│               ├── java.lua               # Main Java module
│               ├── java-utils.lua         # Project utilities
│               ├── build-run.lua          # Build/run scripts
│               ├── dependency-management.lua
│               ├── profiles-management.lua
│               ├── migrations.lua         # Flyway integration
│               └── templates/
│                   ├── java-files.lua     # Java class templates
│                   ├── springboot-files.lua  # Spring Boot templates
│                   ├── quarkus-files.lua     # Quarkus templates
│                   ├── crud-files.lua        # CRUD generator
│                   └── getters-setters.lua   # Getters/Setters
```

### Key Configuration Variables

**JDTLS Config** (`lua/plugins/lang/java.lua`):

- JDK Path: `/usr/lib/jvm/java-21-openjdk/`
- Workspace: `~/.local/share/nvim/jdtls-workspace/`
- Root patterns: `pom.xml`, `build.gradle`, `settings.gradle`

**Mason Tools** (`lua/plugins/lang/mason.lua`):

- `jdtls` - Language server
- `java-debug-adapter` - Debugger support
- `java-test` - Testing framework

---

## Advanced Usage

### Custom Keybindings

Add to `lua/config/keymaps.lua`:

```lua
vim.keymap.set("n", "<leader>jc", function()
  require("plugins.lang.java.java").my_custom_function()
end, { desc = "My Java command" })
```

### Extending Generators

Templates in `lua/plugins/lang/java/templates/`:

- Edit `java-files.lua` for class templates
- Edit `springboot-files.lua` for Spring components
- Edit `crud-files.lua` for CRUD scaffolding

### Custom Maven Commands

Modify `lua/plugins/lang/java/build-run.lua`:

```lua
function M.custom_build = function()
  -- Run custom Maven command
  vim.fn.system("mvn clean install -DskipTests")
end
```

---

## Quick Reference Card

```
GENERAL
  <leader>ji   → Project Info (Framework, Build Tool, Package)
  <leader>jc   → Open Config File (application.properties/yml)
  <leader>?    → Show All Keymaps

BUILD & RUN
  <leader>jrs  → Run Spring Boot
  <leader>jrp  → Run with Profile
  <leader>jrm  → Maven Build
  <leader>jrg  → Gradle Build

GENERATORS
  <leader>jn   → New Java Class (Class/Interface/Enum/Record)
  <leader>js   → New Spring Boot Component
  <leader>jq   → New Quarkus Component
  <leader>jg   → Generate CRUD (Auto-detects framework)
  <leader>jgg  → Generate Getters/Setters

DATABASE
  <leader>jbr  → Run Flyway Migrations
  <leader>jbn  → New Migration File

PROFILES
  <leader>jps  → Switch Profile
  <leader>jpn  → New Profile
  <leader>jpe  → Edit application.properties
  <leader>jpp  → Edit Profile Properties
  <leader>jpi  → Profile Info

DEPENDENCIES
  <leader>jda  → Add Dependency
  <leader>jdt  → Dependency Tree
  <leader>jdu  → Update Dependencies
  <leader>jdv  → Security Check (Vulnerabilities)
```

---

## Resources

- **JDTLS:** https://github.com/eclipse-jdt/eclipse.jdt.ls
- **Eclipse:** https://www.eclipse.org/
- **Maven:** https://maven.apache.org/
- **Gradle:** https://gradle.org/
- **Spring Boot:** https://spring.io/projects/spring-boot
- **Quarkus:** https://quarkus.io/
- **Flyway:** https://flywaydb.org/

---

## Support

For issues:

1. Check JDTLS status: `:LspInfo`
2. View logs: `:LspLog`
3. Restart LSP: `:LspRestart`
4. Clean workspace: `rm -rf ~/.local/share/nvim/jdtls-workspace`

---

**Last Updated:** January 22, 2026  
**NeoVim Version:** 0.9+  
**Java:** JDK 21+  
**Frameworks:** Spring Boot, Quarkus
