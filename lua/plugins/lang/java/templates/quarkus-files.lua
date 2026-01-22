local M = {}
-- ============================================================================
-- Quarkus Templates
-- ============================================================================
local quarkus_templates = {}

quarkus_templates.controller = [[
package %s;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

@Path("/%s")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class %s {

}
]]

quarkus_templates.service = [[
package %s;

import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class %s {

}
]]

quarkus_templates.repository = [[
package %s;

import %s.model.%s;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class %s implements PanacheRepository<%s> {

}
]]

quarkus_templates.entity = [[
package %s;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.*;

@Entity
public class %s extends PanacheEntity {

}
]]

quarkus_templates.dto_request = [[
package %s;

public record %s(
    String name,
    String email
) {}
]]

quarkus_templates.dto_response = [[
package %s;

public record %s(
    Long id,
    String name,
    String email
) {}
]]

quarkus_templates.mapper = [[
package %s;

public interface %s {

}
]]

quarkus_templates.config = [[
package %s;

import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class %s {

}
]]

quarkus_templates.exception = [[
package %s;

public class %s extends RuntimeException {

    public %s(String message) {
        super(message);
    }

    public %s(String message, Throwable cause) {
        super(message, cause);
    }
}
]]

quarkus_templates.exception_handler = [[
package %s;

import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;

@Provider
public class %s implements ExceptionMapper<%s> {

    @Override
    public Response toResponse(%s exception) {
        return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(exception.getMessage())
                .build();
    }
}
]]

-- ============================================================================
-- Generate Quarkus File
-- ============================================================================
local function generate_quarkus_template(kind, name, utils)
  local package_name = utils.detect_package()
  local endpoint = name:lower()
  local entity = name
  local class_name
  local content

  if kind == "Controller" then
    class_name = name .. "Resource"
    content = string.format(quarkus_templates.controller, package_name, endpoint, class_name)
  elseif kind == "Service" then
    class_name = name .. "Service"
    content = string.format(quarkus_templates.service, package_name, class_name)
  elseif kind == "Repository" then
    class_name = name .. "Repository"
    content = string.format(quarkus_templates.repository, package_name, package_name, entity, class_name, entity)
  elseif kind == "Entity" then
    class_name = name
    content = string.format(quarkus_templates.entity, package_name, class_name)
  elseif kind == "DTO Request" then
    class_name = name .. "RequestDTO"
    content = string.format(quarkus_templates.dto_request, package_name, class_name)
  elseif kind == "DTO Response" then
    class_name = name .. "ResponseDTO"
    content = string.format(quarkus_templates.dto_response, package_name, class_name)
  elseif kind == "Mapper" then
    class_name = name .. "Mapper"
    content = string.format(quarkus_templates.mapper, package_name, class_name)
  elseif kind == "Config" then
    class_name = name .. "Config"
    content = string.format(quarkus_templates.config, package_name, class_name)
  elseif kind == "Exception" then
    class_name = name .. "Exception"
    content = string.format(quarkus_templates.exception, package_name, class_name, class_name, class_name)
  elseif kind == "Exception Handler" then
    local exception_name = name .. "Exception"
    class_name = name .. "ExceptionMapper"
    content = string.format(quarkus_templates.exception_handler, package_name, class_name, exception_name, exception_name)
  else
    vim.notify("Template não definido: " .. kind, vim.log.levels.ERROR)
    return
  end

  local dir = vim.fn.expand("%:p:h")
  utils.write_java_file(dir, class_name, content)
end

-- ============================================================================
-- Quarkus Generator Menu
-- ============================================================================
function M.quarkus_generator(utils)
  local options = {
    "Controller",
    "Service",
    "Repository",
    "Entity",
    "DTO Request",
    "DTO Response",
    "Mapper",
    "Config",
    "Exception",
    "Exception Handler",
  }

  vim.ui.select(options, { prompt = "Generate Quarkus file:" }, function(choice)
    if not choice then
      return
    end

    vim.ui.input({ prompt = "Class name (e.g., User): " }, function(name)
      if not name or name == "" then
        return
      end
      generate_quarkus_template(choice, name, utils)
    end)
  end)
end

return M
