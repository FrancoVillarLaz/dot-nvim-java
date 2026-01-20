-- Keymaps específicos para Java/Spring Boot/Quarkus
-- Se cargan en autocmds.lua cuando se abre un archivo .java

local map = vim.keymap.set

--- Crear comando personalizado para Java
vim.api.nvim_create_user_command("JavaRun", function()
  local java_utils = require("config.util.java-utils")
  local project_type = java_utils.get_project_type()

  if project_type == "quarkus" then
    java_utils.run_quarkus_dev()
  elseif project_type == "spring-boot" then
    java_utils.run_spring_boot()
  else
    vim.notify("Unknown project type", vim.log.levels.WARN)
  end
end, { desc = "Run Java/Spring Boot/Quarkus application" })

vim.api.nvim_create_user_command("JavaBuild", function()
  local java_utils = require("config.util.java-utils")
  java_utils.build()
end, { desc = "Build Java application" })

vim.api.nvim_create_user_command("JavaInstall", function()
  local java_utils = require("config.util.java-utils")
  java_utils.install_dependencies()
end, { desc = "Install Java dependencies" })

--- Crear un grupo de autocommands para Java
local java_group = vim.api.nvim_create_augroup("JavaKeyMaps", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = java_group,
  pattern = "java",
  callback = function(opts)
    local bufnr = opts.buf
    local java_utils = require("config.util.java-utils")

    local function jmap(mode, lhs, rhs, desc)
      map(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true, silent = true })
    end

    -- Información del proyecto
    jmap("n", "<leader>jpi", function()
      local project_type = java_utils.get_project_type()
      vim.notify("Project type: " .. project_type, vim.log.levels.INFO)
    end, "Project info")

    -- Ejecutar aplicación
    jmap("n", "<leader>jr", ":JavaRun<CR>", "Run application")

    -- Compilar
    jmap("n", "<leader>jB", ":JavaBuild<CR>", "Build project")

    -- Instalar dependencias
    jmap("n", "<leader>ji", ":JavaInstall<CR>", "Install dependencies")

    -- Ir a archivo de configuración
    jmap("n", "<leader>jcf", function()
      local config_file = java_utils.get_config_file()
      if config_file then
        vim.cmd("edit " .. config_file)
      else
        vim.notify("No configuration file found", vim.log.levels.WARN)
      end
    end, "Config file")
  end,
})
