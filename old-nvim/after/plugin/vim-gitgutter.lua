local status_ok, nvim_tree = pcall(require, 'vim-gitgutter')
if not status_ok then
  return
end
-- Git Gutter

vim.wo.updatetime = 100
vim.wo.signcolumn = "yes"
