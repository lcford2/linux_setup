local builtin = require('telescope.builtin')
-- file searching
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>ft', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fc', builtin.colorscheme, {})
-- buffers
vim.keymap.set('n', '<leader>bb', builtin.buffers, {})
-- spelling
vim.keymap.set('n', '<leader>sc', builtin.spell_suggest, {})
-- git
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
-- vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
-- telescope projects
vim.keymap.set('n', '<leader>fp', require('telescope').extensions.project.project, {})
