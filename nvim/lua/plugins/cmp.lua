-- Autocompletado DISCRETO: aparece, pero no se mete en tu camino.
-- Enter NO acepta nada por su cuenta; <C-Space> lo invoca a mano.
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- fuente: LSP
    "hrsh7th/cmp-buffer",   -- fuente: palabras del buffer
    "hrsh7th/cmp-path",     -- fuente: rutas de archivos
    "L3MON4D3/LuaSnip",     -- motor de snippets
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      completion = { completeopt = "menu,menuone,noinsert" }, -- no preselecciona
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),               -- invocar a mano
        ["<C-e>"] = cmp.mapping.abort(),                      -- cerrar el menú
        ["<CR>"] = cmp.mapping.confirm({ select = false }),   -- solo confirma lo que TÚ elijas
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
    })

    -- Integración con autopairs: cierra el paréntesis al aceptar una función.
    local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    if ok then
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  end,
}
