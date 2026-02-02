return {
  "sphamba/smear-cursor.nvim",
  opts = {
    -- Configuración zen: movimiento suave y natural
    stiffness_insert_mode = 0.3, -- Más suave en insert
    damping_insert_mode = 0.98, -- Más amortiguado
    distance_stop_animating = 0.3,

    time_interval = 12, -- Más lento para ser zen
    cursor_color = "#84a98c", -- Verde musgo zen

    -- Partículas zen - más sutiles
    particles_enabled = true,
    stiffness = 0.3, -- Movimiento muy suave
    trailing_stiffness = 0.1, -- Trail muy sutil
    trailing_exponent = 3,
    damping = 0.8,
    gradient_exponent = 0,
    gamma = 1.2,
    never_draw_over_target = true,
    hide_target_hack = true,

    -- Partículas zen - menos agresivas
    particle_spread = 0.5,
    particles_per_second = 200, -- Menos partículas
    particles_per_length = 20, -- Menos densidad
    particle_max_lifetime = 500, -- Vida más corta
    particle_max_initial_velocity = 10, -- Más lento
    particle_velocity_from_cursor = 0.3,
    particle_damping = 0.25,
    particle_gravity = -30, -- Menos gravedad
    min_distance_emit_particles = 0.1,
  },
}
