local status_ok, nvim_tree = pcall(require, 'nvim_comment')
if not status_ok then
  return
end
require('nvim_comment').setup()
vim.keymap.set("n", "<C+/>", ":CommentToggle<CR>")
