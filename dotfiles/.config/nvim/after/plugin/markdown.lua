local on_attach = function(bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr }
  map({ "n", "i" }, "<C-o>", "<cmd>MDListItemBelow<cr>", opts)
end

require("markdown").setup({
  on_attach = on_attach,
})

