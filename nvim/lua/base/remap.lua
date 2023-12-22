-- give key map to netrw file explorer
vim.keymap.set("n", "<leader>od", vim.cmd.Ex)

-- open undotree
vim.keymap.set("n", "<leader>u", ":UndotreeShow<CR>")

-- Terminal mappings
vim.keymap.set("n", "<leader>ot", ':Term<CR>', { noremap = true }) -- open

-- window rebinds to leader
vim.keymap.set("n", "<leader>w", "<C-w>", { noremap = true })

-- use move command to move highlighted code around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- half page down but stay in middle of screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- search but stay in middle of screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste without overwriting register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- open a terminal below
function OpenTerminal()
  local shell = os.getenv("SHELL")
  local term_open_cmd = "botright split term://" .. shell
  vim.cmd(term_open_cmd)
  vim.cmd("resize 20")
end

vim.keymap.set("n", "<leader>ot", OpenTerminal)

function GetVimWidth()
  -- get the total width of the nvim window
  local info = vim.fn.getwininfo()
  local width = 0
  -- sum over all nvim windows to get the total width
  for window in pairs(info) do
      local window_info = info[window]
      width = width + window_info.width
  end
  return width
end

function GetVimHeight()
  -- get the total height of the nvim window
  local info = vim.fn.getwininfo()
  local height = 0
  -- sum over all nvim windows to get the total height
  for window in pairs(info) do
      local window_info = info[window]
      height = height + window_info.height
  end
  return height
end

function SetWindowWidthAsRatio(ratio)
  -- set the current window width as a ratio of the total width
  local total_width = GetVimWidth()
  local new_width = math.floor(ratio * total_width)
  vim.cmd("vertical resize " .. tostring(new_width))
end

function SetWindowHeightAsRatio(ratio)
  -- set the current window height as a ratio of the total width
  local total_height = GetVimHeight()
  local new_height = math.floor(ratio * total_height)
  vim.cmd("resize " .. tostring(new_height))
end

vim.keymap.set("n", "<leader>wW", function() SetWindowWidthAsRatio(0.8) end, { desc = "Set window to 80% of total width" })
vim.keymap.set("n", "<leader>wV", function() SetWindowHeightAsRatio(0.8) end, { desc = "Set window to 80% of total height" })
