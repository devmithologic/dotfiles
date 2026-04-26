-- ============================================================================
-- init.lua - Neovim config for DevOps/SRE work
-- Minimal but comfortable. Not a full IDE — just good editing.
-- Place at: ~/.config/nvim/init.lua
-- ============================================================================

-- --- General settings ---
vim.opt.number = true                -- Line numbers
vim.opt.relativenumber = true        -- Relative numbers (fast jumping)
vim.opt.tabstop = 2                  -- Tab = 2 spaces
vim.opt.shiftwidth = 2               -- Indent = 2 spaces
vim.opt.expandtab = true             -- Spaces, not tabs
vim.opt.smartindent = true           -- Smart auto-indent
vim.opt.wrap = false                 -- No line wrap
vim.opt.cursorline = true            -- Highlight current line
vim.opt.termguicolors = true         -- True color support
vim.opt.signcolumn = "yes"           -- Always show sign column
vim.opt.scrolloff = 8                -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8            -- Keep 8 cols visible left/right
vim.opt.clipboard = "unnamedplus"    -- System clipboard
vim.opt.ignorecase = true            -- Case insensitive search...
vim.opt.smartcase = true             -- ...unless uppercase used
vim.opt.hlsearch = true              -- Highlight search results
vim.opt.incsearch = true             -- Show matches while typing
vim.opt.splitbelow = true            -- Horizontal splits go below
vim.opt.splitright = true            -- Vertical splits go right
vim.opt.undofile = true              -- Persistent undo
vim.opt.swapfile = false             -- No swap files
vim.opt.updatetime = 250             -- Faster CursorHold
vim.opt.mouse = "a"                  -- Mouse support

-- --- Key mappings ---
vim.g.mapleader = " "                -- Space as leader key

-- Quick save and quit
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>x", ":wq<CR>", { desc = "Save & quit" })

-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Better paste (don't overwrite register)
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting" })

-- Quick file explorer
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "File explorer" })

-- --- YAML settings (critical for k8s manifests) ---
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml", "yml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.cursorcolumn = true    -- Show column guide for indentation
  end,
})

-- --- Highlight on yank ---
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- --- Status line (simple, no plugins needed) ---
vim.opt.statusline = " %f %m %r %= %l:%c  %p%%  %y "
