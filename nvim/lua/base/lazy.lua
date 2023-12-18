-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: lazy.nvim
-- URL: https://github.com/folke/lazy.nvim

-- For information about installed plugins see the README:
-- neovim-lua/README.md
-- https://github.com/brainfucksec/neovim-lua#readme

-- Bootstrap lazy.nvim
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

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
    return
end

-- Start setup
lazy.setup({
    spec = {
        -- Pretty stuff:
        -- panda color scheme
        { 'markvincze/panda-vim',
            lazy = false, -- make sure we load this during startup if it is your main colorscheme
            priority = 1000, -- make sure to load this before all the other start plugins
        },
        {
            'rafi/awesome-vim-colorschemes',
            lazy = false, -- make sure we load this during startup if it is your main colorscheme
            priority = 1000, -- make sure to load this before all the other start plugins
        },
        {
            'sainnhe/everforest',
            lazy = false, -- make sure we load this during startup if it is your main colorscheme
            priority = 1000, -- make sure to load this before all the other start plugins
        },
        {
          'navarasu/onedark.nvim',
          lazy = false, -- make sure we load this during startup if it is your main colorscheme
          priority = 1000, -- make sure to load this before all the other start plugins
        },
        -- Icons
        { 'kyazdani42/nvim-web-devicons', lazy = true },
        -- Dashboard (start screen)
        {
            'goolord/alpha-nvim',
            dependencies = { 'kyazdani42/nvim-web-devicons' },
        },

        -- File navigation
        { 'theprimeagen/harpoon' },
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.3',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        { 'nvim-telescope/telescope-project.nvim' },
        -- File explorer
        {
          'kyazdani42/nvim-tree.lua',
          dependencies = { 'kyazdani42/nvim-web-devicons' },
        },

        -- Editor tools
        { 'mbbill/undotree' },
        { 'terrortylor/nvim-comment' },
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
        -- Git labels
        {
            'lewis6991/gitsigns.nvim',
            lazy = true,
            dependencies = {
                'nvim-lua/plenary.nvim',
                'kyazdani42/nvim-web-devicons',
            },
            config = function()
                require('gitsigns').setup{}
            end
        },
        -- Statusline
        {
            'freddiehaddad/feline.nvim',
            dependencies = {
                'kyazdani42/nvim-web-devicons',
                'lewis6991/gitsigns.nvim',
            },
        },
        -- pydoctstring
        { 'heavenshell/vim-pydocstring' },
        -- vim context
        { 'wellle/context.vim' },
        -- indent blankline
        { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}},

        -- Git Tools
        { 'tpope/vim-fugitive' },
        -- git gutter
        { 'airblade/vim-gitgutter' },

        -- LSP Zero Setup
        {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},
        {'neovim/nvim-lspconfig'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/nvim-cmp'},
        {'L3MON4D3/LuaSnip'},

        -- Tag viewer
        -- { 'preservim/tagbar' },

        -- Autopair
        -- {
        --   'windwp/nvim-autopairs',
        --   event = 'InsertEnter',
        --   config = function()
        --     require('nvim-autopairs').setup{}
        --   end
        -- },

        -- --lazygit
        -- { 'kdheepak/lazygit.nvim' },

      },
    })
