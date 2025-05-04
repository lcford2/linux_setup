local status_ok, diffview = pcall(require, "diffview")

if not status_ok then
  return
end

local actions = require("diffview.config").actions

diffview.setup({
  keymaps = {
    view = {
      ["<leader>q"] = actions.close,
      ["<leader>r"] = actions.refresh_files,
      ["<leader>t"] = actions.toggle_files,
      ["<leader>j"] = actions.select_next_entry,
      ["<leader>k"] = actions.select_prev_entry,
      ["<leader>l"] = actions.focus_files,
      ["<leader>s"] = actions.toggle_stage_entry,
      ["<leader>S"] = actions.stage_all,
      ["<leader>u"] = actions.restore_entry,
    },
    file_panel = {
      ["<leader>q"] = actions.close,
      ["<leader>r"] = actions.refresh_files,
      ["<leader>j"] = actions.select_next_entry,
      ["<leader>k"] = actions.select_prev_entry,
      ["<leader>l"] = actions.focus_entry,
      ["<leader>s"] = actions.toggle_stage_entry,
      ["<leader>S"] = actions.stage_all,
      ["<leader>u"] = actions.restore_entry,
      ["<leader>t"] = actions.toggle_files,
    },
    file_history_panel = {
      ["<leader>q"] = actions.close,
      ["<leader>r"] = actions.refresh_files,
      ["<leader>j"] = actions.select_next_entry,
      ["<leader>k"] = actions.select_prev_entry,
      ["<leader>o"] = actions.toggle_files,
    },
  },
})
