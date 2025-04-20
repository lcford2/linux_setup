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
    {
      'markvincze/panda-vim',
    },
    {
      'rafi/awesome-vim-colorschemes',
    },
    -- everforest (current)
    {
      'sainnhe/everforest',
      lazy = false,    -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
    },
    {
      'navarasu/onedark.nvim',
    },
    -- transparent theme
    -- {
    --   'xiyaowong/transparent.nvim',
    --   lazy = false,
    --   priority = 1000,
    -- },
    -- Rose-pine - Soho vibes for Neovim
    {
      "rose-pine/neovim",
      name = "rose-pine",
      opts = {
        dark_variant = "moon",
      }
    },
    -- Icons
    { 'kyazdani42/nvim-web-devicons',           lazy = true },
    -- Dashboard (start screen)
    {
      'goolord/alpha-nvim',
      dependencies = { 'kyazdani42/nvim-web-devicons' },
    },

    -- File navigation
    {
      'theprimeagen/harpoon',
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.3',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'Snikimonkd/telescope-git-conflicts.nvim',
      }
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
    {
      'TC72/telescope-tele-tabby.nvim',
    },
    {
      'hrsh7th/cmp-path'
    },
    -- File explorer (tree)
    {
      'kyazdani42/nvim-tree.lua',
      dependencies = { 'kyazdani42/nvim-web-devicons' },
    },
    -- File explorer (popup)
    {
      'simonmclean/triptych.nvim',
      event = 'VeryLazy',
      dependencies = {
        'nvim-lua/plenary.nvim',       -- required
        'nvim-tree/nvim-web-devicons', -- optional
      }
    },
    {
      'jvgrootveld/telescope-zoxide'
    },
    {
      'stevearc/oil.nvim',
      opts = {},
      -- Optional dependencies
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Editor tools
    { 'mbbill/undotree' },
    { 'terrortylor/nvim-comment' },
    { 'nvim-treesitter/nvim-treesitter',        build = ':TSUpdate' },
    { 'nvim-treesitter/nvim-treesitter-context' },
    { 'hedyhli/outline.nvim' },
    -- Git labels
    {
      'lewis6991/gitsigns.nvim',
      lazy = true,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function()
        require('gitsigns').setup {}
      end
    },
    -- Statusline
    {
      'lcford2/feline.nvim',
      dependencies = {
        'kyazdani42/nvim-web-devicons',
        'lewis6991/gitsigns.nvim',
      },
    },
    -- terminal manager
    { 'Bhanukamax/tman.nvim' },
    -- doge documentation generator
    { 'kkoomen/vim-doge',                    build = ':call doge#install()' },
    -- indent blankline
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl',                  opts = {} },
    -- highlight todo notes etc
    { 'folke/todo-comments.nvim',            event = "VimEnter",            dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
    -- keybinding help
    {
      'folke/which-key.nvim',
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      opts = {
        win = {
          border = "single",
        },
        layout = {
          align = "center"
        },
      }
    },

    -- Git Tools
    { 'tpope/vim-fugitive' },
    -- git gutter
    { 'airblade/vim-gitgutter' },
    { 'f-person/git-blame.nvim' },
    -- neovim tmux integration
    { 'christoomey/vim-tmux-navigator' },

    -- LSP Zero Setup
    { 'VonHeikemen/lsp-zero.nvim',                branch = 'v3.x' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },

    -- note taking
    {
      'renerocksai/telekasten.nvim',
      dependencies = { 'nvim-telescope/telescope.nvim' },
      event = "VeryLazy",
    },
    {
      'renerocksai/calendar-vim',
      event = "VeryLazy",
    },
    {
      "tadmccorkle/markdown.nvim",
      event = "VeryLazy",
      opts = {
        -- configuration here or empty for defaults
      },
    },

    -- MAKE NVIM CURSOR
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      version = false, -- Never set this value to "*"! Never!
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick",         -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua",              -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        -- "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },

    -- math in buffer
    {
      "lcford2/calc.nvim",
    },

    -- math in buffer (pretty)
    {
      "jbyuki/nabla.nvim"
    },

    -- vim help
    {
      "antonk52/bad-practices.nvim",
    },
    {
      "m4xshen/hardtime.nvim",
      dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
      opts = {}
    },
  },
})
