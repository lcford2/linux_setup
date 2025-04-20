vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

-- indention
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.completeopt = 'menuone,noselect'

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wildmenu = true   -- make tab completion for files/buffers act like bash
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 12
vim.opt.sidescrolloff = 3
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "89"

vim.g.mapleader = " "

-- autocommands
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Remove whitespace on save
autocmd("BufWritePre", {
    pattern = "",
    command = ":%s/\\s\\+$//e"
})

-- Auto format on save using the attached (optionally filtered) language servere clients
-- https://neovim.io/doc/user/lsp.html#vim.lsp.buf.format()
autocmd("BufWritePre", {
    pattern = "",
    command = ":silent lua vim.lsp.buf.format()"
})

-- Don"t auto commenting new lines
autocmd("BufEnter", {
    pattern = "",
    command = "set fo-=c fo-=r fo-=o"
})

-- Set indentation to 2 spaces
augroup('setIndent', { clear = true })
autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
    'yaml', 'lua', 'sh', 'bash', 'zsh', 'cpp', 'hpp', 'c', 'h'
  },
  command = 'setlocal shiftwidth=2 tabstop=2 softtabstop=2'
})

autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'python' },
  command = 'setlocal shiftwidth=4 tabstop=4 softtabstop=4'
})

autocmd('Filetype', {
  pattern = { "cpp", "hpp", "c", "h" },
  command = "lua vim.api.nvim_buf_set_option(0, 'commentstring', '// %s')"
})

autocmd("Filetype", {
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end
})

autocmd('BufEnter', {
  desc = "Set markdown options for telekasten",
  callback = function (opts)
    if vim.bo[opts.buf].filetype == "telekasten" then
      vim.cmd ':setlocal shiftwidth=4 tabstop=4 softtabstop=4'
    end
  end,
})

-- Enter insert mode when switching to terminal
autocmd('TermOpen', {
  command = 'setlocal listchars= nonumber norelativenumber nocursorline',
})

autocmd('TermOpen', {
  pattern = '',
  command = 'startinsert'
})
--
-- Don't auto commenting new lines
autocmd('BufEnter', {
  pattern = '',
  command = 'set fo-=c fo-=r fo-=o'
})

-- Close terminal buffer on process exit
autocmd('BufLeave', {
  pattern = 'term://*',
  command = 'stopinsert'
})
autocmd("TermClose", {
    callback = function()
       vim.cmd("close")
    end
})
