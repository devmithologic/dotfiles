-- Trouble: un panel con TODOS los errores/avisos en un solo lugar.
-- Buenísimo revisando: ves de un vistazo qué está mal sin abrir archivo por archivo.
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup()
    vim.keymap.set("n", "<leader>dd", ":Trouble diagnostics toggle<CR>", { desc = "Diagnósticos: panel (proyecto)" })
    vim.keymap.set("n", "<leader>db", ":Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Diagnósticos: panel (este archivo)" })
    vim.keymap.set("n", "<leader>dt", ":Trouble todo toggle<CR>", { desc = "TODOs: panel" })
  end,
}
