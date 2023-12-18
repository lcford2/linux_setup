--[[

Neovim init file
Maintainer: brainf+ck
Website: https://github.com/brainfucksec/neovim-lua

--]]

vim.wo.number = true
vim.g.tagbar_ctags_bin = "/home/lucas/.local/bin/ctags"
vim.g.pydocstring_doq_path = "/home/lucas/.local/bin/doq"
vim.g.pydocstring_formatter = "google"
-- vim.g.doge_enable_mappings = 0
-- vim.g.doge_doc_standard_python = "google"


-- Import Lua modules
require('core/lazy')
require('core/autocmds')
require('core/keymaps')
require('core/colors')
require('core/statusline')
require('core/options')
require('lsp/lspconfig')
require('plugins/nvim-tree')
require('plugins/indent-blankline')
require('plugins/nvim-cmp')
require('plugins/nvim-treesitter')
require('plugins/alpha-nvim')
require('plugins/telescope')
require('plugins/nvim-comment')
require('plugins/vim-gitgutter')

