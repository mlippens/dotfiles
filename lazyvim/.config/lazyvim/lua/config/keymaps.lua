-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { desc = "Navigate Left" })
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { desc = "Navigate Right" })
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { desc = "Navigate Down" })
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { desc = "Navigate Up" })
