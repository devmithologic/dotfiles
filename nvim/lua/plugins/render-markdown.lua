-- render-markdown: dibuja el markdown formateado DENTRO del buffer mientras editas.
-- En modo NORMAL lo ves renderizado (títulos, viñetas, casillas, tablas);
-- al entrar en INSERT muestra el texto crudo de esa línea, para editar cómodo.
-- Necesita treesitter (ya lo tienes) y una Nerd Font (ya la tienes).
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" }, -- se carga solo al abrir archivos .md
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("render-markdown").setup({
      latex = { enabled = false }, -- latex necesita un conversor externo; lo apago para evitar avisos
    })
    -- alterna el renderizado on/off (útil si quieres ver el crudo completo)
    vim.keymap.set("n", "<leader>m", "<cmd>RenderMarkdown toggle<CR>", { desc = "Markdown: render on/off" })
  end,
}
