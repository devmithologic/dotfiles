return  { 
  "folke/tokyonight.nvim", 
  name = "tokyonight", 
  lazy = false,
  priority = 1000,
  opts = {},
-- config
  config = function()
    require("tokyonight").setup({
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    })
    vim.cmd.colorscheme "tokyonight-night"
  end
}
