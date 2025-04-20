local status_ok, tman = pcall(require, "tman")

if not status_ok then
  return
end

tman.setup({
  split = "bottom",
  width = 50,
  height = 30,
})
