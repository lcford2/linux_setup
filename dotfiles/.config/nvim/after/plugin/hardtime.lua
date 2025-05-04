local status_ok, hardtime = pcall(require, "hardtime")
if not status_ok then
  return
end

local disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "oil", "mason" }
local disable_mouse = false

hardtime.setup({
  disabled_filetypes = disabled_filetypes,
  disable_mouse = disable_mouse,
})
hardtime.enable()
