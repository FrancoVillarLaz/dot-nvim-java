local M = {}

-- ============================================================================
-- Parse Java Fields from Current File
--
-- ============================================================================
local function parse_java_fields()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local fields = {}

  for line_num, line in ipairs(lines) do
    -- Match: private/protected/public Type fieldName; or Type fieldName;
    local visibility, field_type, field_name = line:match("^%s*(private%s+)([%w<>%[%]]+)%s+([%w_]+)%s*[;=]")
    if not visibility then
      visibility, field_type, field_name = line:match("^%s*(protected%s+)([%w<>%[%]]+)%s+([%w_]+)%s*[;=]")
    end
    if not visibility then
      visibility, field_type, field_name = line:match("^%s*(public%s+)([%w<>%[%]]+)%s+([%w_]+)%s*[;=]")
    end

    if field_type and field_name then
      -- Skip static/final fields
      if not line:match("static") and not line:match("final") then
        table.insert(fields, {
          name = field_name,
          type = field_type,
          line = line_num,
          visibility = visibility and visibility:match("^%s*(.-)%s*$") or "private",
        })
      end
    end
  end

  return fields
end

-- ============================================================================
-- Generate Getter
-- ============================================================================
local function generate_getter(field)
  local getter_name = "get" .. field.name:sub(1, 1):upper() .. field.name:sub(2)

  -- Boolean fields use "is" prefix
  if field.type == "boolean" or field.type == "Boolean" then
    getter_name = "is" .. field.name:sub(1, 1):upper() .. field.name:sub(2)
  end

  return string.format(
    [[
    public %s %s() {
        return this.%s;
    }]],
    field.type,
    getter_name,
    field.name
  )
end

-- ============================================================================
-- Generate Setter
-- ============================================================================
local function generate_setter(field)
  local setter_name = "set" .. field.name:sub(1, 1):upper() .. field.name:sub(2)

  return string.format(
    [[
    public void %s(%s %s) {
        this.%s = %s;
    }]],
    setter_name,
    field.type,
    field.name,
    field.name,
    field.name
  )
end

-- ============================================================================
-- Find Class End Position
-- ============================================================================
local function find_class_end()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local brace_count = 0
  local in_class = false
  local class_end = #lines

  for line_num, line in ipairs(lines) do
    -- Detect class declaration
    if line:match("^%s*public%s+class%s+") or line:match("^%s*class%s+") then
      in_class = true
    end

    if in_class then
      -- Count braces
      for char in line:gmatch(".") do
        if char == "{" then
          brace_count = brace_count + 1
        elseif char == "}" then
          brace_count = brace_count - 1
          if brace_count == 0 then
            class_end = line_num - 1
            return class_end
          end
        end
      end
    end
  end

  return class_end
end

-- ============================================================================
-- Insert Methods at Class End
-- ============================================================================
local function insert_methods(methods)
  local insert_line = find_class_end()

  -- Split multiline strings into individual lines
  local lines = {}
  table.insert(lines, "") -- Add blank line before methods

  for _, method in ipairs(methods) do
    if method == "" then
      table.insert(lines, "")
    else
      -- Split by newlines and add each line
      for line in method:gmatch("[^\r\n]+") do
        table.insert(lines, line)
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, insert_line, insert_line, false, lines)

  -- Format the buffer if possible
  vim.defer_fn(function()
    local ok = pcall(vim.lsp.buf.format, { async = false })
    if not ok then
      vim.notify("Generated methods. Auto-format not available.", vim.log.levels.WARN)
    end
  end, 100)
end

-- ============================================================================
-- Main Generator Function
-- ============================================================================
function M.generate_getters_setters()
  local fields = parse_java_fields()

  if #fields == 0 then
    vim.notify("No fields found in current file", vim.log.levels.WARN)
    return
  end

  -- Create options for selection
  local options = {}
  for _, field in ipairs(fields) do
    table.insert(options, string.format("%s %s", field.type, field.name))
  end

  -- Multi-select fields
  vim.ui.select(options, {
    prompt = "Select fields (press number, then choose action):",
    format_item = function(item)
      return item
    end,
  }, function(choice, idx)
    if not choice then
      return
    end

    local selected_field = fields[idx]

    -- Ask what to generate
    vim.ui.select({
      "Getter only",
      "Setter only",
      "Both Getter & Setter",
      "Generate for ALL fields",
    }, {
      prompt = "Generate:",
    }, function(action)
      if not action then
        return
      end

      local methods = {}

      if action == "Generate for ALL fields" then
        -- Generate for all fields
        for _, field in ipairs(fields) do
          table.insert(methods, generate_getter(field))
          table.insert(methods, "")
          table.insert(methods, generate_setter(field))
          table.insert(methods, "")
        end
      else
        -- Generate for selected field
        if action == "Getter only" then
          table.insert(methods, generate_getter(selected_field))
        elseif action == "Setter only" then
          table.insert(methods, generate_setter(selected_field))
        elseif action == "Both Getter & Setter" then
          table.insert(methods, generate_getter(selected_field))
          table.insert(methods, "")
          table.insert(methods, generate_setter(selected_field))
        end
      end

      insert_methods(methods)
      vim.notify(string.format("✨ Generated %s", action), vim.log.levels.INFO)
    end)
  end)
end

return M
