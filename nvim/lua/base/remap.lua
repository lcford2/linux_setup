-- give key map to netrw file explorer
vim.keymap.set("n", "<leader>od", vim.cmd.Ex)

-- open undotree
vim.keymap.set("n", "<leader>u", ":UndotreeShow<CR>")

-- Terminal mappings
vim.keymap.set("n", "<leader>ot", ':Term<CR>', { noremap = true })  -- open

-- window rebinds to leader
vim.keymap.set("n", "<leader>w", "<C-w>", { noremap = true})
