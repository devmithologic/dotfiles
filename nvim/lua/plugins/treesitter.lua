-- Treesitter: resaltado y comprensión de estructura precisos.
-- Clave para LEER código que no escribiste (vibe coding / review).
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- la API .configs.setup vive en master (estable)
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "python", "typescript", "tsx", "javascript",
        "json", "yaml", "bash", "lua", "markdown", "markdown_inline",
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
