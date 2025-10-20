-- kakoune-like selection-first editing for Neovim
-- Lowercase = fresh motion
-- Uppercase = extend selection (Kakoune-style)
-- Counts work (e.g. 5w, 3E). Operators (d,y,c,>,=) act on the selection.
-- k = delete (selection or char).  x/X = linewise extend.
--------------------------------------------------------------------------------

vim.g.mapleader = ' '

-- sensible options
local o = vim.opt
-- o.number         = true
-- o.relativenumber = true
-- o.mouse          = 'a'
-- o.wrap           = true
-- o.linebreak      = true
-- o.breakindent    = true
-- o.tabstop        = 4
-- o.shiftwidth     = 4
-- o.expandtab      = true
o.signcolumn     = 'yes'
o.clipboard      = 'unnamedplus'
o.ignorecase     = true
o.smartcase      = true
-- o.termguicolors  = true
o.scrolloff      = 999
-- o.laststatus     = 3
-- o.completeopt    = { 'menu','menuone','noselect' }

-- vim.g.matchup_matchparen_offscreen = {}
-- enable lateral motion
-- vim.opt.whichwrap:append("<>,hl")
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


--------------------------------------------------------------------------------
-- helpers
--------------------------------------------------------------------------------
local api = vim.api
local fn  = vim.fn

local function is_visual()
  return fn.mode():find('[vV\022]') ~= nil
end

local function read_char()
  local ok, ch = pcall(fn.getcharstr)
  if ok and ch and ch ~= '' then return ch end
  return nil
end

local function feedkeys(seq)
  local s = api.nvim_replace_termcodes(seq, true, false, true)
  api.nvim_feedkeys(s, 'n', true)
end

--------------------------------------------------------------------------------
-- selection creators
--------------------------------------------------------------------------------
local function make_nav_select(motion, needs_char)
  return function()
    local cnt = vim.v.count > 0 and tostring(vim.v.count) or ''
    local ch
    if needs_char then
      ch = read_char()
      if not ch then return end
    end
    feedkeys('<Esc>v' .. cnt .. motion .. (ch or ''))
  end
end

local function make_nav_extend(motion, needs_char)
  return function()
    local cnt = vim.v.count > 0 and tostring(vim.v.count) or ''
    local ch
    if needs_char then
      ch = read_char()
      if not ch then return end
    end
    local prefix = is_visual() and '' or 'v'
    feedkeys(prefix .. cnt .. motion .. (ch or ''))
  end
end

-- character motions (special Kakoune-like behavior)
-- local function make_char_select(direction)
--   return function()
--     local cnt = vim.v.count > 0 and tostring(vim.v.count) or ''
--     local move = ({ h='h', j='j', k='k', l='l' })[direction]
--     if not move then return end
--     -- if in visual: exit it first
--     local prefix = is_visual() and '<Esc>' or ''
--     feedkeys(prefix .. cnt .. move)
--    -- feedkeys('<Esc>v')
--   end
-- end

-- local function make_char_select(direction)
--   return function()
--     local count = vim.v.count > 0 and vim.v.count or 1
--     local move = ({ h = 'h', j = 'j', k = 'k', l = 'l' })[direction]
--     if not move then return end
--
--     local prefix = is_visual() and '<Esc>' or ''
--
--     if count > 1 then
--       -- For multiple characters, use visual + motion to select all at once
--       local keys = prefix .. 'v' .. tostring(count) .. move
--       vim.api.nvim_feedkeys(
--         vim.api.nvim_replace_termcodes(keys, true, false, true),
--         'n',
--         true
--       )
--     else
--       -- For single character: move, then re-enter visual mode (your preferred behavior)
--       feedkeys(prefix .. move)
--       feedkeys('<Esc>v')
--     end
--   end
-- end
--


local function make_char_extend(direction)
  return function()
    local cnt = vim.v.count > 0 and tostring(vim.v.count) or ''
    local move = ({ h='h', j='j', k='k', l='l' })[direction]
    if not move then return end
    local prefix = is_visual() and '' or 'v'
    feedkeys(prefix .. cnt .. move)
  end
end

-- linewise extend (x/X)
local function make_extend_lines(direction)
  return function()
    local cnt = (vim.v.count > 0) and vim.v.count or 1
    local move = (direction == 'down') and 'j' or 'k'
    if fn.mode() ~= 'V' then
      if cnt > 1 then
        feedkeys('V' .. tostring(cnt - 1) .. move)
      else
        feedkeys('V')
      end
    else
      feedkeys(tostring(cnt) .. move)
    end
  end
end

-- mapping helper - TBD: make word motions etc remap in operation pending mode
local function map_sel(lhs, fn, desc)
  vim.keymap.set({'n','v'}, lhs, fn, { noremap = true, silent = true, desc = desc })
end

--------------------------------------------------------------------------------
-- Core mappings
--------------------------------------------------------------------------------

-- handy escape
vim.keymap.set({'i','v','o','t'}, 'qq',
  function() return vim.fn.mode() == 't' and [[<C-\><C-n>]] or '<Esc>' end,
  { expr = true, silent = true })

--------------------------------------------------------------------------------
-- character motions
--------------------------------------------------------------------------------
-- map_sel('s', make_char_select('h'), '← move')
-- map_sel('d', make_char_select('j'), '↓ move')
-- map_sel('f', make_char_select('l'), '→ move')
-- map_sel('e', make_char_select('k'), '↑ move')

-- Normal mode
vim.keymap.set('n', 's', 'h', { silent = true, desc = 'move left' })
vim.keymap.set('n', 'd', 'gj', { silent = true, desc = 'move down' })
vim.keymap.set('n', 'f', 'l', { silent = true, desc = 'move up' })
vim.keymap.set('n', 'e', 'gk', { silent = true, desc = 'move right' })

-- Visual mode
vim.keymap.set('v', 's', '<Esc>h', { silent = true, desc = 'move left' })
vim.keymap.set('v', 'd', '<Esc>gj', { silent = true, desc = 'move down' })
vim.keymap.set('v', 'f', '<Esc>l', { silent = true, desc = 'move up' })
vim.keymap.set('v', 'e', '<Esc>gk', { silent = true, desc = 'move right' })


map_sel('S', make_char_extend('h'), '← extend char')
map_sel('D', make_char_extend('j'), '↓ extend char')
map_sel('F', make_char_extend('l'), '→ extend char')
map_sel('E', make_char_extend('k'), '↑ extend char')

--------------------------------------------------------------------------------
-- word motions
--------------------------------------------------------------------------------
map_sel('w', make_nav_select('w', false), '→ word select')
map_sel('b', make_nav_select('b', false), '← word select')
map_sel('l', make_nav_select('e', false), '→ word-end select')
vim.keymap.set('o', 'l', 'e', { silent = true, desc = 'move word-end' })
map_sel('j', make_nav_select('b', false),  '← word select')
vim.keymap.set('o', 'j', 'b', { silent = true, desc = 'move word-start' })

map_sel('W', make_nav_extend('w', false), '→ word extend')
map_sel('B', make_nav_extend('b', false), '← word extend')
map_sel('L', make_nav_extend('e', false), '→ word-end extend')
map_sel('J', make_nav_extend('B', false),  '← word extend')

--------------------------------------------------------------------------------
-- find/till motions
--------------------------------------------------------------------------------
-- map_sel('b', make_nav_select('f', true), 'blip to the matched char select')
-- vim.keymap.set('o', 'b', 'f', { silent = true, desc = 'blip to the mathed char' })
-- map_sel('B', make_nav_select('F', true), 'blip till char extend')
-- map_sel('j', make_nav_select('f', true), 'to char select')
-- map_sel('J', make_nav_extend('f', true), 'to char extend')

--------------------------------------------------------------------------------
-- linewise extend
--------------------------------------------------------------------------------
-- map_sel('x', make_extend_lines('down'), 'linewise ↓')
-- map_sel('X', make_extend_lines('up'),   'linewise ↑')

-- vim.keymap.set({'n', 'v', 'o'}, 'c', 'x', { noremap = true, silent = true, desc = 'c to clear' })
-- vim.keymap.set({'n', 'v', 'o'}, 'c', 'd', { noremap = true, silent = true, desc = 'c to clear' })
-- vim.keymap.set({'n', 'v', 'o'}, 'b', 't', { noremap = true, silent = true, desc = 'b to blip to char or word' })
vim.keymap.set({'n', 'v', 'o'}, 'c', 'd', { noremap = true, silent = true, desc = 't to trim' })

-- replace selection with register
vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = true, desc = 'Replace selection with register (Kakoune style)' })

--------------------------------------------------------------------------------
-- extras
--------------------------------------------------------------------------------
-- backspace to act as s in normal, blackhole delete in visual
vim.keymap.set({'n'}, '<BS>', 's',
  { noremap = true, silent = true, desc = 'backspace to delete char and insert' })
vim.keymap.set({'v'}, '<BS>', '"_s',
  { noremap = true, silent = true, desc = 'backspace to remove selection without yanking' })


vim.keymap.set({'n', 'v'}, '^', 'ggVG', { noremap = true, silent = true, desc = 'select entire file (override ^)' })
vim.keymap.set('o', '^', ':<C-u>normal! ggVG<CR>', { noremap = true, silent = true, desc = 'operate on entire file (override ^)' })

-- vim.keymap.set('n', '<A-d>', ':m .+1<CR>==', { silent = true })
-- vim.keymap.set('n', '<A-e>', ':m .-2<CR>==', { silent = true })
-- vim.keymap.set('i', '<A-d>', '<Esc>:m .+1<CR>==gi', { silent = true })
-- vim.keymap.set('i', '<A-e>', '<Esc>:m .-2<CR>==gi', { silent = true })
-- vim.keymap.set('v', '<A-d>', ":m '>+1<CR>gv=gv", { silent = true })
-- vim.keymap.set('v', '<A-e>', ":m '<-2<CR>gv=gv", { silent = true })

-- U = redo
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = 'Redo' })

vim.keymap.set('v', '<', '<gv') -- keep selection when indenting
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })

-- auto command to highlight copied selection
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'highlight the copied selection',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {clear = true}),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- -- little flash when buffer changed
-- vim.api.nvim_create_autocmd('TextChanged', {
--   callback = function()
--     vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
--   end,
-- })
--
-- -- highlight the word under the cursor
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   callback = function()
--     vim.fn.matchadd('IncSearch', '\\V' .. vim.fn.escape(vim.fn.expand('<cword>'), '\\'))
--   end,
-- })
