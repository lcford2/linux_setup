local builtin = require('telescope.builtin')
pcall(require('telescope').load_extension, 'fzf')
-- file searching
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set('n', '<leader>ft', builtin.live_grep, { desc = "[F]ind [T]ext" })
vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "[F]ind [G]it files" })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = "[F]ind [R]ecent files" })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "[F]ind [K]eymaps" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "[F]ind [H]elp tags" })
vim.keymap.set('n', '<leader>fc', builtin.colorscheme, { desc = "[F]ind [C]olorschemes" })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
-- buffers
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "[F]ind [B]uffers" })
-- spelling
vim.keymap.set('n', '<leader>sc', builtin.spell_suggest, { desc = "[S]pell [C]heck" })
-- git
vim.keymap.set('n', '<leader>fgc', builtin.git_commits, { desc = "[F]ind [G]it [C]ommits" })
vim.keymap.set('n', '<leader>fgb', builtin.git_branches, { desc = "[F]ind [G]it [B]ranches" })
-- vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
-- telescope projects
vim.keymap.set('n', '<leader>fp', require('telescope').extensions.project.project,
  { desc = "[F]ind [P]rojects" })
