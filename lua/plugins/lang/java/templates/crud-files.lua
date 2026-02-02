-- ============================================================================
-- 🥇 CRUD GENERATOR
-- ============================================================================

local M = {}

-- Detect framework type (Spring Boot or Quarkus)
local function detect_framework()
  local project_root = vim.fn.getcwd()
  local pom_file = project_root .. "/pom.xml"
  local gradle_file = project_root .. "/build.gradle"
  
  -- Check pom.xml
  if vim.fn.filereadable(pom_file) == 1 then
    local pom_content = vim.fn.readfile(pom_file)
    local pom_text = table.concat(pom_content, "\n")
    if pom_text:match("quarkus") then
      return "quarkus"
    elseif pom_text:match("spring%-boot") then
      return "spring"
    end
  end
  
  -- Check build.gradle
  if vim.fn.filereadable(gradle_file) == 1 then
    local gradle_content = vim.fn.readfile(gradle_file)
    local gradle_text = table.concat(gradle_content, "\n")
    if gradle_text:match("quarkus") then
      return "quarkus"
    elseif gradle_text:match("spring%-boot") then
      return "spring"
    end
  end
  
  return "spring" -- Default to Spring Boot
end

function M.generate_crud()
  vim.ui.input({ prompt = "Nome da entidade (ex: Product): " }, function(name)
    if not name or name == "" then
      return
    end

    vim.ui.input({ prompt = "Campos (ex: name:String,price:Double,active:Boolean): " }, function(fields_input)
      local fields = {}
      if fields_input and fields_input ~= "" then
        for field_def in fields_input:gmatch("[^,]+") do
          local field_name, field_type = field_def:match("([^:]+):([^:]+)")
          if field_name and field_type then
            table.insert(fields, { name = field_name:match("^%s*(.-)%s*$"), type = field_type:match("^%s*(.-)%s*$") })
          end
        end
      end

      local utils = require("plugins.lang.java.java-utils")
      local package_name = utils.detect_package()
      local base_package = package_name:match("(.+)%.[^.]+$") or package_name
      local project_root = vim.fn.getcwd()
      local framework = detect_framework()

      -- Entity
      local entity_fields = ""
      for i, field in ipairs(fields) do
        entity_fields = entity_fields .. string.format("    private %s %s;\n", field.type, field.name)
      end

      local entity_content
      if framework == "quarkus" then
        -- Quarkus Entity with Panache
        entity_content = string.format(
          [[
package %s.model;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.*;

@Entity
@Table(name = "%s")
public class %s extends PanacheEntity {

%s}
]],
          base_package,
          name:lower(),
          name,
          entity_fields
        )
      else
        -- Spring Boot Entity
        entity_content = string.format(
          [[
package %s.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "%s")
public class %s {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

%s}
]],
          base_package,
          name:lower(),
          name,
          entity_fields
        )
      end

      -- Repository
      local repository_content
      if framework == "quarkus" then
        -- Quarkus Repository with Panache
        repository_content = string.format(
          [[
package %s.repository;

import %s.model.%s;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class %sRepository implements PanacheRepository<%s> {

}
]],
          base_package,
          base_package,
          name,
          name,
          name
        )
      else
        -- Spring Boot Repository
        repository_content = string.format(
          [[
package %s.repository;

import %s.model.%s;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface %sRepository extends JpaRepository<%s, Long> {

}
]],
          base_package,
          base_package,
          name,
          name,
          name
        )
      end

      -- DTO Request
      local dto_request_fields = ""
      for _, field in ipairs(fields) do
        dto_request_fields = dto_request_fields .. string.format("    %s %s", field.type, field.name)
        if _ < #fields then
          dto_request_fields = dto_request_fields .. ",\n"
        else
          dto_request_fields = dto_request_fields .. "\n"
        end
      end

      local dto_request_content = string.format(
        [[
package %s.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record %sRequestDTO(
%s) {}
]],
        base_package,
        name,
        dto_request_fields
      )

      -- DTO Response
      local dto_response_fields = "    Long id"
      if #fields > 0 then
        dto_response_fields = dto_response_fields .. ",\n"
      end
      for i, field in ipairs(fields) do
        dto_response_fields = dto_response_fields .. string.format("    %s %s", field.type, field.name)
        if i < #fields then
          dto_response_fields = dto_response_fields .. ",\n"
        else
          dto_response_fields = dto_response_fields .. "\n"
        end
      end

      local dto_response_content = string.format(
        [[
package %s.dto;

public record %sResponseDTO(
%s) {}
]],
        base_package,
        name,
        dto_response_fields
      )

      -- Service
      local service_content
      if framework == "quarkus" then
        -- Quarkus Service using Panache Entity
        service_content = string.format(
          [[
package %s.service;

import %s.dto.%sRequestDTO;
import %s.dto.%sResponseDTO;
import %s.model.%s;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
public class %sService {

    @Transactional
    public %sResponseDTO create(%sRequestDTO dto) {
        %s entity = new %s();
        // TODO: Map DTO to Entity
        entity.persist();
        return toDTO(entity);
    }

    public List<%sResponseDTO> findAll() {
        return %s.listAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public %sResponseDTO findById(Long id) {
        %s entity = %s.findById(id);
        if (entity == null) {
            throw new RuntimeException("%s not found with id: " + id);
        }
        return toDTO(entity);
    }

    @Transactional
    public %sResponseDTO update(Long id, %sRequestDTO dto) {
        %s entity = %s.findById(id);
        if (entity == null) {
            throw new RuntimeException("%s not found with id: " + id);
        }
        // TODO: Update entity from DTO
        return toDTO(entity);
    }

    @Transactional
    public void delete(Long id) {
        %s entity = %s.findById(id);
        if (entity == null) {
            throw new RuntimeException("%s not found with id: " + id);
        }
        entity.delete();
    }

    private %sResponseDTO toDTO(%s entity) {
        return new %sResponseDTO(
            entity.id
            // TODO: Add other fields
        );
    }
}
]],
          base_package,
          base_package, name,
          base_package, name,
          base_package, name,
          name,
          name, name,
          name, name,
          name,
          name,
          name, name, name, name,
          name, name,
          name, name, name,
          name, name, name,
          name, name,
          name
        )
      else
        -- Spring Boot Service
        service_content = string.format(
          [[
package %s.service;

import %s.dto.%sRequestDTO;
import %s.dto.%sResponseDTO;
import %s.model.%s;
import %s.repository.%sRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class %sService {

    private final %sRepository repository;

    public %sService(%sRepository repository) {
        this.repository = repository;
    }

    @Transactional
    public %sResponseDTO create(%sRequestDTO dto) {
        %s entity = new %s();
        // TODO: Map DTO to Entity
        entity = repository.save(entity);
        return toDTO(entity);
    }

    @Transactional(readOnly = true)
    public List<%sResponseDTO> findAll() {
        return repository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public %sResponseDTO findById(Long id) {
        return repository.findById(id)
                .map(this::toDTO)
                .orElseThrow(() -> new RuntimeException("%s not found with id: " + id));
    }

    @Transactional
    public %sResponseDTO update(Long id, %sRequestDTO dto) {
        %s entity = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("%s not found with id: " + id));
        // TODO: Update entity from DTO
        entity = repository.save(entity);
        return toDTO(entity);
    }

    @Transactional
    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new RuntimeException("%s not found with id: " + id);
        }
        repository.deleteById(id);
    }

    private %sResponseDTO toDTO(%s entity) {
        return new %sResponseDTO(
            entity.getId()
            // TODO: Add other fields
        );
    }
}
]],
          base_package,
          base_package, name,
          base_package, name,
          base_package, name,
          base_package, name,
          name,
          name,
          name, name,
          name, name,
          name, name,
          name,
          name,
          name, name,
          name, name, name,
          name,
          name, name,
          name
        )
      end

      -- Controller/Resource
      local controller_or_resource_content
      local controller_filename
      local controller_subpackage

      if framework == "quarkus" then
        -- Quarkus Resource (JAX-RS)
        controller_filename = name .. "Resource"
        controller_subpackage = "resource"
        controller_or_resource_content = string.format(
          [[
package %s.resource;

import %s.dto.%sRequestDTO;
import %s.dto.%sResponseDTO;
import %s.service.%sService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("/api/%s")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class %sResource {

    @Inject
    %sService service;

    @POST
    public Response create(@Valid %sRequestDTO dto) {
        return Response.status(Response.Status.CREATED)
                .entity(service.create(dto))
                .build();
    }

    @GET
    public List<%sResponseDTO> findAll() {
        return service.findAll();
    }

    @GET
    @Path("/{id}")
    public %sResponseDTO findById(@PathParam("id") Long id) {
        return service.findById(id);
    }

    @PUT
    @Path("/{id}")
    public %sResponseDTO update(@PathParam("id") Long id, @Valid %sRequestDTO dto) {
        return service.update(id, dto);
    }

    @DELETE
    @Path("/{id}")
    public Response delete(@PathParam("id") Long id) {
        service.delete(id);
        return Response.noContent().build();
    }
}
]],
          base_package,
          base_package, name,
          base_package, name,
          base_package, name,
          name:lower(),
          name,
          name,
          name,
          name,
          name,
          name, name
        )
      else
        -- Spring Boot Controller
        controller_filename = name .. "Controller"
        controller_subpackage = "controller"
        controller_or_resource_content = string.format(
          [[
package %s.controller;

import %s.dto.%sRequestDTO;
import %s.dto.%sResponseDTO;
import %s.service.%sService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/%s")
public class %sController {

    private final %sService service;

    public %sController(%sService service) {
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<%sResponseDTO> create(@Valid @RequestBody %sRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(dto));
    }

    @GetMapping
    public ResponseEntity<List<%sResponseDTO>> findAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<%sResponseDTO> findById(@PathVariable Long id) {
        return ResponseEntity.ok(service.findById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<%sResponseDTO> update(@PathVariable Long id, @Valid @RequestBody %sRequestDTO dto) {
        return ResponseEntity.ok(service.update(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
]],
          base_package,
          base_package, name,
          base_package, name,
          base_package, name,
          name:lower(),
          name,
          name,
          name, name,
          name, name,
          name,
          name,
          name, name,
          name
        )
      end

      -- Creates the directories and files
      local function create_file(subpackage, filename, content)
        local dir = project_root .. "/src/main/java/" .. base_package:gsub("%.", "/") .. "/" .. subpackage
        vim.fn.mkdir(dir, "p")
        local full_path = dir .. "/" .. filename .. ".java"
        local file = io.open(full_path, "w")
        if file then
          file:write(content)
          file:close()
        end
      end

      create_file("model", name, entity_content)
      
      -- Repository: only for Spring (Quarkus uses PanacheEntity)
      if framework == "spring" then
        create_file("repository", name .. "Repository", repository_content)
      end
      
      create_file("dto", name .. "RequestDTO", dto_request_content)
      create_file("dto", name .. "ResponseDTO", dto_response_content)
      create_file("service", name .. "Service", service_content)
      
      -- Controller (Spring) or Resource (Quarkus)
      create_file(controller_subpackage, controller_filename, controller_or_resource_content)

      local success_message
      if framework == "quarkus" then
        success_message = string.format(
          "✨ Quarkus CRUD generado para %s!\n📁 Entity (Panache), Resource, Service, y DTOs creados.",
          name
        )
      else
        success_message = string.format(
          "✨ Spring Boot CRUD generado para %s!\n📁 Entity, Repository, Service, Controller, y DTOs creados.",
          name
        )
      end

      vim.notify(success_message, vim.log.levels.INFO)
    end)
  end)
end

return M
