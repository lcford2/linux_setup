-- window rebinds to leader
vim.keymap.set("n", "<leader>w", "<C-w>", { desc = "Window", noremap = true })

-- use move command to move highlighted code around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- half page down but stay in middle of screen
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
-- search but stay in middle of screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste without overwriting register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "No overwrite paste" })

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to sys clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to sys clipboard" })

-- exit terminal mode
vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", {})

-- open a terminal below
function OpenTerminal()
  local shell = os.getenv("SHELL")
  if shell == nil then
    shell = "/bin/bash"
  end
  local term_open_cmd = "botright split term://" .. shell
  vim.cmd(term_open_cmd)
  vim.cmd("resize 20")
end

function GetVimWidth()
  return vim.o.columns
end

function GetVimHeight()
  return vim.o.lines
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

function ZoomWindow()
  local total_width = GetVimWidth()
  local total_height = GetVimHeight()

  -- Calculate new width and height for 80% of the available space
  local new_width = math.floor(total_width * 0.8)
  local new_height = math.floor(total_height * 0.8)

  if #vim.api.nvim_tabpage_list_wins(0) == 1 then
    -- Only one window, make it full screen
    vim.cmd("resize " .. total_height)
    vim.cmd("vertical resize " .. total_width)
  else
    -- Resize to 80%
    vim.cmd("resize " .. new_height)
    vim.cmd("vertical resize " .. new_width)
  end
end
