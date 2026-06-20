-- Comodidades pequeñas.
-- NOTA: comentar líneas con gcc / gc (visual) YA es nativo en Neovim 0.10+,
-- así que no instalamos plugin para eso.
return {
  -- Cierra paréntesis, comillas y corchetes automáticamente.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  -- Resalta y lista TODO / FIXME / NOTE / HACK en el código.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
      local td = require("todo-comments")
      vim.keymap.set("n", "]t", function() td.jump_next() end, { desc = "TODO: siguiente" })
      vim.keymap.set("n", "[t", function() td.jump_prev() end, { desc = "TODO: anterior" })
    end,
  },
}
