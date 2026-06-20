-- Gitsigns: el corazón de tu flujo "revisar diffs locales".
-- Muestra en el margen qué líneas añadiste/cambiaste/borraste, y te deja
-- previsualizar, stagear o descartar cada bloque (hunk) sin salir de nvim.
return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
        end
        -- navegar entre cambios
        map("]c", function() gs.nav_hunk("next") end, "Git: siguiente cambio")
        map("[c", function() gs.nav_hunk("prev") end, "Git: cambio anterior")
        -- inspeccionar / actuar sobre un cambio (hunk)
        map("<leader>gp", gs.preview_hunk, "Git: previsualizar cambio")
        map("<leader>gs", gs.stage_hunk, "Git: stage del cambio")
        map("<leader>gr", gs.reset_hunk, "Git: descartar cambio")
        map("<leader>gb", function() gs.blame_line({ full = true }) end, "Git: blame de la línea")
        map("<leader>gB", gs.toggle_current_line_blame, "Git: blame en línea (toggle)")
      end,
    })
  end,
}
