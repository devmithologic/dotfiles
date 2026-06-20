-- Which-key: al empezar a teclear un atajo, te muestra las opciones disponibles.
-- Tu mejor amigo mientras aprendes nvim. Lee el `desc` de cada atajo.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup()
  end,
}
