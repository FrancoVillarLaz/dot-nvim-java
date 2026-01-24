local function setup_custom_java_keymaps()
  local java = require("plugins.lang.java.java")

  -- ========== LSP/IMPORTS ==========
  vim.keymap.set("n", "<leader>jo", function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.organizeImports" } }
    })
  end, { desc = "Organize Imports" })

  vim.keymap.set("n", "<leader>jla", vim.lsp.buf.code_action, { desc = "LSP Code Actions" })
  
  vim.keymap.set("n", "<leader>jlm", function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.addMissingImports" } }
    })
  end, { desc = "Add Missing Imports" })

  vim.keymap.set("n", "<leader>jlu", function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.removeUnusedImports" } }
    })
  end, { desc = "Remove Unused Imports" })

  -- ========== BUILD E RUN ==========
  vim.keymap.set("n", "<leader>jrs", java.spring_boot_run, { desc = "Run Spring Boot" })
  vim.keymap.set("n", "<leader>jrp", java.spring_boot_run_profile, { desc = "Run with Profile" })
  vim.keymap.set("n", "<leader>jrm", java.maven_build, { desc = "Maven Build" })
  vim.keymap.set("n", "<leader>jrg", java.gradle_build, { desc = "Gradle Build" })

  -- ========== GERADORES ==========
  vim.keymap.set("n", "<leader>jn", java.file_generator, { desc = "New Java File" })
  vim.keymap.set("n", "<leader>js", java.spring_boot_generator, { desc = "New Spring File" })
  vim.keymap.set("n", "<leader>jq", java.quarkus_generator, { desc = "New Quarkus File" })
  vim.keymap.set("n", "<leader>jg", java.generate_crud, { desc = "Generate CRUD" })
  vim.keymap.set("n", "<leader>jgg", java.generate_getters_setters, { desc = "Generate Getters/Setters" })

  -- ========== PROJECT INFO ==========
  vim.keymap.set("n", "<leader>ji", java.show_project_info, { desc = "Project Info" })

  -- ========== DATABASE ==========
  vim.keymap.set("n", "<leader>jbr", java.flyway_migrate, { desc = "Run Flyway Migrate" })
  vim.keymap.set("n", "<leader>jbn", java.create_migration, { desc = "New Migration" })

  -- ========== PROFILES ==========
  vim.keymap.set("n", "<leader>jps", java.switch_profile, { desc = "Switch Profile" })
  vim.keymap.set("n", "<leader>jpn", java.create_new_profile, { desc = "New Profile" })
  vim.keymap.set("n", "<leader>jpe", java.edit_properties, { desc = "Edit Properties Config" })
  vim.keymap.set("n", "<leader>jpp", java.edit_profile_properties, { desc = "Edit Profile Config" })
  vim.keymap.set("n", "<leader>jpi", java.show_profile_info, { desc = "Profile Info" })

  -- ========== DEPENDENCIES ==========
  vim.keymap.set("n", "<leader>jda", java.add_dependency, { desc = "Add Dependency" })
  vim.keymap.set("n", "<leader>jdt", java.show_dependency_tree, { desc = "Dependency Tree" })
  vim.keymap.set("n", "<leader>jdu", java.update_dependencies, { desc = "Update Dependencies" })
  vim.keymap.set("n", "<leader>jdv", java.check_vulnerabilities, { desc = "Check Vulnerabilities" })

  -- ========== CONFIG ==========
  vim.keymap.set("n", "<leader>jc", function()
    local java_utils = require("config.util.java-utils")
    local config_file = java_utils.get_config_file()
    if config_file then
      vim.cmd("edit " .. config_file)
    else
      vim.notify("No configuration file found", vim.log.levels.WARN)
    end
  end, { desc = "Open Config File" })

  -- Setup which-key
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({
      { "<leader>j", group = "java" },
      { "<leader>jr", group = "Run/Build" },
      { "<leader>jb", group = "Database" },
      { "<leader>jp", group = "Profile" },
      { "<leader>jd", group = "Dependencies" },
      { "<leader>jl", group = "LSP" },
    })
  end

  -- ========== AUTOCMD: AUTO ORGANIZE IMPORTS ON SAVE ==========
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0, -- Only for current buffer (Java file)
    callback = function()
      -- Only run if this is actually a Java file
      if vim.bo.filetype ~= "java" then
        return
      end
      
      local params = vim.lsp.util.make_range_params()
      params.context = { only = { "source.organizeImports" } }
      local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 5000)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
          else
            vim.lsp.buf.execute_command(r.command)
          end
        end
      end
    end,
    desc = "Auto organize imports (Java)"
  })
end

-- Load keymaps when opening Java file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = setup_custom_java_keymaps,
})

return { setup = setup_custom_java_keymaps }
