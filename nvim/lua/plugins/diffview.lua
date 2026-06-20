-- Diffview: revisa TODOS los cambios de golpe, como un Pull Request,
-- lado a lado. Es tu vista de "code review" antes de commitear.
return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup()
    vim.keymap.set("n", "<leader>gv", ":DiffviewOpen<CR>", { desc = "Git: revisar cambios (diffview)" })
    vim.keymap.set("n", "<leader>gc", ":DiffviewClose<CR>", { desc = "Git: cerrar diffview" })
    vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "Git: historial del archivo" })
  end,
}
