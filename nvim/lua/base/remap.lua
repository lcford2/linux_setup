-- give key map to netrw file explorer
vim.keymap.set("n", "<leader>od", vim.cmd.Ex)

-- open undotree
vim.keymap.set("n", "<leader>u", ":UndotreeShow<CR>")

-- Terminal mappings
vim.keymap.set("n", "<leader>ot", ':Term<CR>', { noremap = true })  -- open

-- window rebinds to leader
vim.keymap.set("n", "<leader>w", "<C-w>", { noremap = true})

-- use move command to move highlighted code around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- half page down but stay in middle of screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<leader>F", vim.lsp.buf.format)
