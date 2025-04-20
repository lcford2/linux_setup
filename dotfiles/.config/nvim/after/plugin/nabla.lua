local nabla = require("nabla")

vim.keymap.set("n", "<leader>e", nabla.popup, { desc = "No overwrite paste" })
-- nnoremap <leader>p :lua require("nabla").popup()<CR> " Customize with popup({border = ...})  : `single` (default), `double`, `rounded`

