local telekasten = require("telekasten")

telekasten.setup({
  home = vim.fn.expand("~/telekasten")
})

vim.cmd [[
unlet g:calendar_monday
]]

vim.g.calendar_weeknm = 2
