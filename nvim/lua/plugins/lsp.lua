-- LSP "equilibrado" con la API nativa de Neovim 0.11 (vim.lsp.config / enable).
-- mason instala los servidores; nvim-lspconfig solo aporta las configs base.
return {
  {
    "williamboman/mason.nvim",
    config = true, -- = require("mason").setup()
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        -- pyright: tipos Python | ruff: lint Python | ts_ls: TS/React
        ensure_installed = { "pyright", "ruff", "ts_ls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- capacidades para que el autocompletado (cmp) sepa qué ofrece el LSP
      local caps = require("cmp_nvim_lsp").default_capabilities()

      -- API nueva: añade capacidades a TODOS los servidores de una vez
      vim.lsp.config("*", { capabilities = caps })

      -- enciende los servidores (sus configs base las trae nvim-lspconfig)
      vim.lsp.enable({ "pyright", "ruff", "ts_ls" })

      -- mostrar los mensajes de diagnóstico en línea (visibles pero limpios)
      vim.diagnostic.config({ virtual_text = true, severity_sort = true })

      -- Atajos: se activan SOLO cuando un LSP se adjunta a un archivo.
      -- (Evito el prefijo "gr" porque Neovim 0.11 ya lo usa de forma nativa.)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "LSP: ir a definición")
          map("gD", vim.lsp.buf.declaration, "LSP: ir a declaración")
          map("K", vim.lsp.buf.hover, "LSP: documentación (hover)")
          map("<leader>cr", vim.lsp.buf.references, "Código: referencias")
          map("<leader>ci", vim.lsp.buf.implementation, "Código: implementación")
          map("<leader>rn", vim.lsp.buf.rename, "Código: renombrar")
          map("<leader>ca", vim.lsp.buf.code_action, "Código: code action")
          map("<leader>cd", vim.diagnostic.open_float, "Diagnóstico: ver en línea")
          map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Diagnóstico: anterior")
          map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Diagnóstico: siguiente")
        end,
      })
    end,
  },
} 
