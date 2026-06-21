-- ============================================================================
-- init.lua - Neovim config for DevOps/SRE work
-- Minimal but comfortable. Not a full IDE — just good editing.
-- Place at: ~/.config/nvim/init.lua
-- ============================================================================

-- Desactiva netrw para que Neo-tree sea el único explorador (evita el error E95)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("lazy").setup("plugins")

