-- Keymaps are automatically loaded on the VeryLazy event Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Discipline plugin
local discipline = require("fernandor.discipline")
discipline.cowboy()

local keymap = vim.keymap
-- local opts = { noremap = true, silent = true }

-- Move lines with vim arrow style
keymap.set("n", "<C-k>", ":m .-2<Return>==")
keymap.set("n", "<C-j>", ":m .+1<Return>==")
keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Select all
keymap.set("n", "<leader>p", "gg<S-v><S-g>", { desc = "Select all text from buffer" })

-- Better tabing
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

--- Navigate throuh the page
keymap.set("n", "sh", "H", { desc = "Cursor on top of screen" })
keymap.set("n", "sl", "L", { desc = "Cursor on bottom of screen" })

-- Oil like vinegar keymap
keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Note: When using ctrl + w on insert mode, it will delete the last word you wrote.
