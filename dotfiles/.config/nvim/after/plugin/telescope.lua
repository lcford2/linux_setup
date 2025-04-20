local status_ok, telescope = pcall(require, "telescope")

if not status_ok then
  return
end

telescope.setup({
  defaults = {
    prompt_prefix = "   ",
  },
  extensions = {
    tele_tabby = {
      use_highlighter = true,
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
})

telescope.load_extension("fzf")
telescope.load_extension("harpoon")
telescope.load_extension("tele_tabby")
telescope.load_extension("conflicts")
telescope.load_extension("zoxide")
