"" commentary
noremap <C-_> gcc

"" set leader key to space
:let mapleader = " "

"" NVim Tree
noremap <leader>or :NvimTreeToggle<CR>

"" Tagbar
noremap <leader>ol :TagbarToggle<CR>

"" Telescope
" files
noremap <leader>ff <cmd>Telescope find_files<cr>
noremap <leader>fg <cmd>Telescope live_grep<cr>
noremap <leader>fb <cmd>Telescope buffers<cr>
noremap <leader>fr <cmd>Telescope oldfiles<cr>
" git
noremap <leader>gc <cmd>Telescope git_commits<cr>
noremap <leader>gs <cmd>Telescope git_status<cr>
noremap <leader>gb <cmd>Telescope git_branches<cr>
" projects
noremap <leader>pp <cmd>Telescope projects<cr>
" colorscheme
noremap <leader>cs <cmd>Telescope colorscheme<cr>
" man pages
noremap <leader>mp <cmd>Telescope man_pages<cr>
" key bindings
noremap <leader>kb <cmd>Telescope keymaps<cr>

"" BarBar
map <A-h> :BufferPrevious<CR>
map <A-l> :BufferNext<CR>

"" Window commands
" move cursor
noremap <leader>wh <cmd>wincmd h<cr>
noremap <leader>wj <cmd>wincmd j<cr>
noremap <leader>wk <cmd>wincmd k<cr>
noremap <leader>wl <cmd>wincmd l<cr>
" splits
noremap <leader>ws <cmd>wincmd s<cr>
noremap <leader>wv <cmd>wincmd v<cr>
" resize equal
noremap <leader>w= <cmd>wincmd =<cr>
" change height
noremap <leader>w- <cmd>resize -2<cr>
noremap <leader>w+ <cmd>resize +2<cr>
" change width
noremap <leader>w< <cmd>vertical resize -2<cr>
noremap <leader>w> <cmd>vertical resize +2<cr>
" close window
noremap <leader>wc <cmd>close<cr>
