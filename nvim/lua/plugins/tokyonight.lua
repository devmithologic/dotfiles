return  { 
  "folke/tokyonight.nvim", 
  name = "tokyonight", 
  lazy = false,
  priority = 1000,
  opts = {},
-- config
  config = function()
    vim.cmd.colorscheme "tokyonight-night"
  end
}
