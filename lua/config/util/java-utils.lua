-- Utilidades específicas para Java, Spring Boot y Quarkus
local M = {}

--- Detectar si un proyecto es Spring Boot
function M.is_spring_boot()
  local root = vim.fn.getcwd()
  return vim.fn.filereadable(root .. "/pom.xml") == 1 or vim.fn.filereadable(root .. "/build.gradle") == 1
end

--- Detectar si un proyecto es Quarkus
function M.is_quarkus()
  local root = vim.fn.getcwd()
  if vim.fn.filereadable(root .. "/pom.xml") == 1 then
    local pom_content = vim.fn.readfile(root .. "/pom.xml")
    local pom_string = table.concat(pom_content, "\n")
    return pom_string:match("quarkus") ~= nil
  end
  if vim.fn.filereadable(root .. "/build.gradle") == 1 then
    local gradle_content = vim.fn.readfile(root .. "/build.gradle")
    local gradle_string = table.concat(gradle_content, "\n")
    return gradle_string:match("quarkus") ~= nil
  end
  return false
end

--- Obtener el tipo de proyecto
function M.get_project_type()
  if M.is_quarkus() then
    return "quarkus"
  elseif M.is_spring_boot() then
    return "spring-boot"
  else
    return "java"
  end
end

--- Obtener el archivo de configuración (application.properties o application.yml)
function M.get_config_file()
  local root = vim.fn.getcwd()
  if vim.fn.filereadable(root .. "/src/main/resources/application.yml") == 1 then
    return root .. "/src/main/resources/application.yml"
  elseif vim.fn.filereadable(root .. "/src/main/resources/application.yaml") == 1 then
    return root .. "/src/main/resources/application.yaml"
  elseif vim.fn.filereadable(root .. "/src/main/resources/application.properties") == 1 then
    return root .. "/src/main/resources/application.properties"
  end
  return nil
end

--- Ejecutar la aplicación Spring Boot
function M.run_spring_boot()
  local root = vim.fn.getcwd()
  if vim.fn.filereadable(root .. "/mvnw") == 1 then
    vim.cmd("terminal ./mvnw spring-boot:run")
  elseif vim.fn.filereadable(root .. "/gradlew") == 1 then
    vim.cmd("terminal ./gradlew bootRun")
  else
    vim.notify("No Maven wrapper or Gradle wrapper found", vim.log.levels.ERROR)
  end
end

--- Ejecutar la aplicación Quarkus en dev mode
function M.run_quarkus_dev()
  local root = vim.fn.getcwd()
  if vim.fn.filereadable(root .. "/mvnw") == 1 then
    vim.cmd("terminal ./mvnw quarkus:dev")
  elseif vim.fn.filereadable(root .. "/gradlew") == 1 then
    vim.cmd("terminal ./gradlew quarkusDev")
  else
    vim.notify("No Maven wrapper or Gradle wrapper found", vim.log.levels.ERROR)
  end
end

--- Compilar el proyecto
function M.build()
  local root = vim.fn.getcwd()
  if vim.fn.filereadable(root .. "/mvnw") == 1 then
    vim.cmd("terminal ./mvnw clean package")
  elseif vim.fn.filereadable(root .. "/gradlew") == 1 then
    vim.cmd("terminal ./gradlew clean build")
  else
    vim.notify("No Maven wrapper or Gradle wrapper found", vim.log.levels.ERROR)
  end
end

--- Instalar dependencias
function M.install_dependencies()
  local root = vim.fn.getcwd()
  if vim.fn.filereadable(root .. "/mvnw") == 1 then
    vim.cmd("terminal ./mvnw dependency:resolve")
  elseif vim.fn.filereadable(root .. "/gradlew") == 1 then
    vim.cmd("terminal ./gradlew build --refresh-dependencies")
  else
    vim.notify("No Maven wrapper or Gradle wrapper found", vim.log.levels.ERROR)
  end
end

return M
