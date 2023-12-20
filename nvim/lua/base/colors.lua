vim.opt.background = "dark"
vim.cmd.colorscheme("everforest")

local M = {}

local everforest_palette = {
  bg_dim = '#1e2326',
  bg0 = '#272e33',
  bg1 = '#2e383c',
  bg2 = '#374145',
  bg3 = '#414b50',
  bg4 = '#495156',
  bg5 = '#4f5b58',
  bg_visual = '#4c3743',
  bg_red = '#493b40',
  bg_green = '#3c4841',
  bg_blue = '#384b55',
  bg_yellow = '#45443c',
  fg = '#d3c6aa',
  red = '#e67e80',
  orange = '#e69875',
  yellow = '#dbbc7f',
  green = '#a7c080',
  aqua = '#83c092',
  blue = '#7fbbb3',
  purple = '#d699b6',
  grey0 = '#7a8478',
  grey1 = '#859289',
  grey2 = '#9da9a0',
  statusline1 = '#a7c080',
  statusline2 = '#d3c6aa',
  statusline3 = '#e67e80',
}

M.everforest = {
  bg = everforest_palette.bg0,
  fg = everforest_palette.fg,
  pink = everforest_palette.red,
  green = everforest_palette.green,
  cyan = everforest_palette.purple,
  yellow = everforest_palette.yellow,
  orange = everforest_palette.orange,
  red = everforest_palette.red,
}

return M


-- local status_ok, color_scheme = pcall(require, 'onedark')
-- if not status_ok then
--   return
-- end
--
-- -- Note: The instruction to load the color scheme may vary.
-- -- See the README of the selected color scheme for the instruction
-- -- to use.
-- -- e.g.: require('color_scheme').setup{}, vim.cmd('color_scheme') ...
-- require('onedark').setup {
--   -- styles: dark, darker, cool, deep, warm, warmer, light
--   style = 'darker',
--   colors = { fg = '#b2bbcc' }, --default: #a0a8b7
-- }
-- require('onedark').load()
--
-- local M = {}
--
-- -- Theme: OneDark (dark)
-- -- Colors: https://github.com/navarasu/onedark.nvim/blob/master/lua/onedark/palette.lua
-- M.onedark_dark = {
--   bg = '#282c34',
--   fg = '#b2bbcc',
--   pink = '#c678dd',
--   green = '#98c379',
--   cyan = '#56b6c2',
--   yellow = '#e5c07b',
--   orange = '#d19a66',
--   red = '#e86671',
-- }
--
-- return M
