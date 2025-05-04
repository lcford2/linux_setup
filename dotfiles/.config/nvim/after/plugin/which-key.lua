local harpoon = require("harpoon")
-- harpoon telescope function
local function toggle_telescope(harpoon_files)
  local conf = require("telescope.config").values
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

local tman = require("tman")

local opts = {
  mode = "n",     -- NORMAL mode
  prefix = " ",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
  expr = false,   -- use `expr` when creating keymaps
}

-- Using the format that matches the which-key suggested spec
local mappings = {
  -- Find section
  { " f",   name = "Find" },
  { " ff",  "<cmd>Telescope find_files<cr>",                                                       desc = "Find File" },
  { " ft",  "<cmd>Telescope live_grep<cr>",                                                        desc = "Grep" },
  { " fT",  "<cmd>Telescope current_buffer_fuzze_find<cr>",                                        desc = "Fuzzy Find in File" },
  { " fr",  "<cmd>Telescope oldfiles<cr>",                                                         desc = "Recent Files" },
  { " fk",  "<cmd>Telescope keymaps<cr>",                                                          desc = "Find Keymaps" },
  { " fh",  "<cmd>Telescope help_tags<cr>",                                                        desc = "Find Help Tags" },
  { " fc",  "<cmd>Telescope colorscheme<cr>",                                                      desc = "Find Colorscheme" },
  { " fd",  "<cmd>Telescope diagnostics<cr>",                                                      desc = "Find Diagnostics" },
  -- Find Git section
  { " fg",  name = "Git" },
  { " fgf", "<cmd>Telescope git_files<cr>",                                                        desc = "Files" },
  { " fgc", "<cmd>Telescope git_commits<cr>",                                                      desc = "Commits" },
  { " fgb", "<cmd>Telescope git_branches<cr>",                                                     desc = "Branches" },

  -- Buffers section
  { " b",   name = "Buffers" },
  { " bl",  "<cmd>bprev<cr>",                                                                      desc = "Last Buffer" },
  { " bn",  "<cmd>bnext<cr>",                                                                      desc = "Next Buffer" },
  { " bb",  "<cmd>Telescope buffers<cr>",                                                          desc = "Find Buffers" },

  -- GoTo section
  { " g",   name = "GoTo" },
  { " gd",  function() require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" }) end, desc = "Definition" },
  { " gD",  vim.lsp.buf.declaration,                                                               desc = "Declaration" },
  { " gi",  vim.lsp.buf.implementation,                                                            desc = "Implementation" },
  { " gt",  vim.lsp.buf.type_definition,                                                           desc = "Type Definition" },

  -- LSP section
  { " l",   name = "LSP" },
  -- LSP Workspace section
  { " lw",  name = "Workspace" },
  { " lwa", vim.lsp.buf.add_workspace_folder,                                                      desc = "Add Folder" },
  { " lwr", vim.lsp.buf.remove_workspace_folder,                                                   desc = "Remove Folder" },
  { " lwl", vim.lsp.buf.list_workspace_folders,                                                    desc = "List Folders" },
  -- Other LSP commands
  { " lr",  vim.lsp.buf.rename,                                                                    desc = "Rename" },
  { " la",  vim.lsp.buf.code_action,                                                               desc = "Code Action" },
  { " lf",  vim.lsp.buf.format,                                                                    desc = "Format Buffer" },
  { " ln",  function() vim.diagnostic.goto_next() end,                                             desc = "Next Problem" },
  { " lp",  function() vim.diagnostic.goto_prev() end,                                             desc = "Previous Problem" },
  { " lh",  vim.lsp.buf.hover,                                                                     desc = "Function Help" },
  { " ls",  "<cmd>Telescope lsp_document_symbols<cr>",                                             desc = "Document Symbols" },
  { " lR",  "<cmd>Telescope lsp_references<cr>",                                                   desc = "References" },

  -- Git section
  { " G",   name = "Git" },
  { " Gs",  vim.cmd.Git,                                                                           desc = "Status" },
  { " Gp",  "<cmd>Git push<cr>",                                                                   desc = "Push" },
  { " GP",  "<cmd>Git pull<cr>",                                                                   desc = "Pull" },
  { " Gc",  "<cmd>Git checkout<cr>",                                                               desc = "Checkout" },
  { " Gd",  "<cmd>DiffviewOpen<cr>",                                                               desc = "Diff View" },
  { " Gh",  function() require("gitsigns").stage_hunk() end,                                       desc = "Stage hunk under cursor." },
  { " GH",  function() require("gitsigns").reset_hunk() end,                                       desc = "Restore hunk under cursor." },
  -- Harpoon
  { " h",   name = "Harpoon" },
  { " ha",  function() harpoon:list():append() end,                                                desc = "Add File" },
  { " hm",  function() toggle_telescope(harpoon:list()) end,                                       desc = "Menu" },
  { " hJ",  function() harpoon:list():next() end,                                                  desc = "Next File" },
  { " hK",  function() harpoon:list():prev() end,                                                  desc = "Previous File" },
  { " hh",  function() harpoon:list():select(1) end,                                               desc = "File 1" },
  { " hj",  function() harpoon:list():select(2) end,                                               desc = "File 2" },
  { " hk",  function() harpoon:list():select(3) end,                                               desc = "File 3" },
  { " hl",  function() harpoon:list():select(4) end,                                               desc = "File 4" },
  { " he",  function() harpoon:list():clear() end,                                                 desc = "Clear Marks" },

  -- Open configs
  { " o",   name = "Open" },
  { " ou",  vim.cmd.UndotreeToggle,                                                                desc = "UndoTree" },
  { " od",  "<cmd>Oil<cr>",                                                                        desc = "File Explorer" },
  { " ot",  function() tman.toggleLast({ insert = true }) end,                                     desc = "Terminal" },
  { " or",  tman.toggleRight,                                                                      desc = "Terminal Right" },

  -- Sidebar
  { " s",   name = "Sidebar" },
  { " sl",  "<cmd>NvimTreeToggle<cr>",                                                             desc = "Left (nvim-tree)" },
  { " sr",  "<cmd>Outline<cr>",                                                                    desc = "Right (outline)" },

  -- Terminal
  { " t",   name = "Terminal" },
  { " tt",  function() tman.toggleLast({ insert = true }) end,                                     desc = "Terminal" },
  { " tr",  tman.toggleRight,                                                                      desc = "Terminal Right" },
  { " tc",  ":TmanCmd<CR>",                                                                        desc = "Send Terminal Command" },
  { " tl",  ":TmanCmdLast<CR>",                                                                    desc = "Send Last Terminal Command" },

  -- Window configs
  { " w",   name = "Window" },
  { " wW",  function() SetWindowWidthAsRatio(0.8) end,                                             desc = "Set window to 80% of total width" },
  { " wV",  function() SetWindowHeightAsRatio(0.8) end,                                            desc = "Set window to 80% of total height" },
  { " wz",  function() ZoomWindow() end,                                                           desc = "Zoom Window" },

  -- Notes (commented out)
  -- { " n", name = "Notes" },
  -- { " nn", "<cmd>Telekasten new_note<cr>", desc = "New Note" },
  -- { " nf", "<cmd>Telekasten find_notes<cr>", desc = "Find Note" },
  -- { " nt", "<cmd>Telekasten show_tags<cr>", desc = "Show Tags" },
  -- { " ns", "<cmd>Telekasten search_notes<cr>", desc = "Search Notes" },
  -- { " nd", "<cmd>Telekasten find_daily_notes<cr>", desc = "Find Daily Note" },
  -- { " nD", "<cmd>Telekasten goto_today<cr>", desc = "Goto Today's Note" },
  -- { " nc", "<cmd>Telekasten show_calendar<cr>", desc = "Calendar" },
  -- { " nl", "<cmd>Telekasten insert_link<cr>", desc = "Insert Link" },
  -- { " nL", "<cmd>Telekasten show_backlinks<cr>", desc = "Show Links to Note" },
  -- { " nT", "<cmd>Telekasten toggle_todo<cr>", desc = "Toggle Todo" },
  -- { " nw", "<cmd>Telekasten find_weekly_notes<cr>", desc = "Find Weekly Note" },
  -- { " nW", "<cmd>Telekasten goto_thisweek<cr>", desc = "Goto This Week's Note" },
}

local wk = require("which-key")
-- wk.register(mappings, opts)
wk.add(mappings)
