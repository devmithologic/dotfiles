return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    auto_restore = true,
    auto_save = true,
    -- Cierra Neo-tree ANTES de guardar la sesión, para que no se restaure
    -- un buffer de directorio que choca con Neo-tree al navegar (origen del E95).
    pre_save_cmds = { "Neotree close" },
  },
}
