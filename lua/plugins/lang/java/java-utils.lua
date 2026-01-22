local M = {}

-- ============================================================================
--  Only utilities that LazyVim does NOT provide
-- ============================================================================

-- Safe File Reader
local function read_file_lines(filepath, max_lines)
  max_lines = max_lines or 1000

  local success, content = pcall(vim.fn.readfile, filepath, "", max_lines)

  return success and content or {}
end

-- Detect package from current file
function M.detect_package()
  local current_file = vim.fn.expand("%:p")
  local project_root = vim.fn.getcwd()

  if not current_file or current_file == "" then
    return "com.example"
  end

  -- Attempt to read file package
  if current_file:match("%.java$") then
    local file_content = read_file_lines(current_file, 100)
    for _, line in ipairs(file_content) do
      local package_match = line:match("^package%s+([%w%.]+)%s*;")
      if package_match then
        return package_match
      end
    end
  end

  -- Inferring from the directory structure
  local current_dir = vim.fn.expand("%:p:h")
  local main_java = project_root .. "/src/main/java"
  local test_java = project_root .. "/src/test/java"

  local function get_package_from_path(base_path)
    if not base_path or not current_dir:find(base_path, 1, true) then
      return nil
    end
    local relative_path = current_dir:sub(#base_path + 2)
    if relative_path and relative_path ~= "" then
      return relative_path:gsub("/", ".")
    end
    return nil
  end

  return get_package_from_path(main_java) or get_package_from_path(test_java) or "com.example"
end

-- Detect build tool
function M.get_build_tool()
  local cwd = vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. "/pom.xml") == 1 then
    return "maven"
  elseif vim.fn.filereadable(cwd .. "/build.gradle") == 1 or vim.fn.filereadable(cwd .. "/build.gradle.kts") == 1 then
    return "gradle"
  end
  return nil
end

-- Detect framework type
function M.detect_framework()
  local project_root = vim.fn.getcwd()
  local pom_file = project_root .. "/pom.xml"
  local gradle_file = project_root .. "/build.gradle"
  local gradle_kts_file = project_root .. "/build.gradle.kts"

  -- Check pom.xml
  if vim.fn.filereadable(pom_file) == 1 then
    local pom_content = read_file_lines(pom_file)
    local pom_text = table.concat(pom_content, "\n")
    if pom_text:match("quarkus") then
      return "Quarkus"
    elseif pom_text:match("spring%-boot") then
      return "Spring Boot"
    end
  end

  -- Check build.gradle
  if vim.fn.filereadable(gradle_file) == 1 then
    local gradle_content = read_file_lines(gradle_file)
    local gradle_text = table.concat(gradle_content, "\n")
    if gradle_text:match("quarkus") then
      return "Quarkus"
    elseif gradle_text:match("spring%-boot") then
      return "Spring Boot"
    end
  end

  -- Check build.gradle.kts
  if vim.fn.filereadable(gradle_kts_file) == 1 then
    local gradle_content = read_file_lines(gradle_kts_file)
    local gradle_text = table.concat(gradle_content, "\n")
    if gradle_text:match("quarkus") then
      return "Quarkus"
    elseif gradle_text:match("spring%-boot") then
      return "Spring Boot"
    end
  end

  return "Java"
end

-- Show project information
function M.show_project_info()
  local framework = M.detect_framework()
  local build_tool = M.get_build_tool() or "Unknown"
  local package_name = M.detect_package()
  
  local info = string.format(
    "📦 Project Information\n\n" ..
    "Framework: %s\n" ..
    "Build Tool: %s\n" ..
    "Package: %s",
    framework,
    build_tool,
    package_name
  )
  
  vim.notify(info, vim.log.levels.INFO)
end

-- Write Java file
function M.write_java_file(dir, class_name, content)
  vim.fn.mkdir(dir, "p")
  local full_path = dir .. "/" .. class_name .. ".java"

  local file = io.open(full_path, "w")
  if file then
    file:write(content)
    file:close()
    vim.cmd("edit " .. vim.fn.fnameescape(full_path))
    vim.notify("Created: " .. class_name)
  else
    vim.notify("Failed to write file: " .. full_path, vim.log.levels.ERROR)
  end
end

return M
