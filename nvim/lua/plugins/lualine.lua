return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
-- config
  config = function()
    require("lualine").setup({
      options = {
        theme = "tokyonight-moon"
      }
    })
  end
}
