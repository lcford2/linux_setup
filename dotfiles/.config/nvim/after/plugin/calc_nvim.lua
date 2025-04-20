local calc = require("calc_nvim")

calc.setup({
  float_format="0.9f",
  log_level="DEBUG",
})
vim.keymap.set("v", "<C-c>", calc.calculate, {})
vim.keymap.set("v", "<C-f>", calc.format_number, {})
