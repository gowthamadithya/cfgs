vim.g.mapleader = ' '

-- sensible options
local o = vim.opt
o.number         = true
o.relativenumber = true
o.mouse          = 'a'
o.wrap           = true
o.linebreak      = true
o.breakindent    = true
o.tabstop        = 4
o.shiftwidth     = 4
o.expandtab      = true
o.signcolumn     = 'yes'
o.clipboard      = 'unnamedplus'
o.ignorecase     = true
o.smartcase      = true
o.termguicolors  = true
o.scrolloff      = 999
o.laststatus     = 3
o.completeopt    = { 'menu','menuone','noselect' }

-- enable lateral motion
vim.opt.whichwrap:append("<>,hl")
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- map e, s, d, f to navigate and select up, down, left, right
vim.keymap.set({'n', 'v', 'o'}, 'e', '<Esc>gkv', { desc = 'Move up by visual line' })
vim.keymap.set({'n', 'v', 'o'}, 'd', '<Esc>gjv', { desc = 'Move down by visaul line' })
vim.keymap.set({'n', 'v', 'o'}, 's', '<Esc>hv', { desc = 'Move left' })
vim.keymap.set({'n', 'v', 'o'}, 'f', '<Esc>lv', { desc = 'Move right' })

-- map E, S, D, F to navigate and extend selection up, down, left, right
vim.keymap.set({'n', 'v', 'o'}, 'E', 'gk', { desc = 'Move up by visual line' })
vim.keymap.set({'n', 'v', 'o'}, 'D', 'gj', { desc = 'Move up by visual line' })
vim.keymap.set({'n', 'v', 'o'}, 'S', 'h', { desc = 'Move up by visual line' })
vim.keymap.set({'n', 'v', 'o'}, 'F', 'l', { desc = 'Move up by visual line' })


vim.keymap.set({'n', 'v', 'o'}, 'w', '<Esc>vw', { desc = 'Move by a word' })
vim.keymap.set({'n', 'v', 'o'}, 'W', 'w', { desc = 'Extend by a word' })


-- vim.keymap.set({'n', 'v', 'o'}, 'w', '<Esc>wv', { desc = 'Move by a word' })
-- vim.keymap.set({'n', 'v', 'o'}, 'W', 'w', { desc = 'Extend by a word' })
--

-- Automatically enter Visual Mode on startup
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  command = "normal! v",  -- Enter characterwise Visual mode
})

-- escapes to visual by default
vim.keymap.set('i', '<Esc>', '<Esc>v', { noremap = true, silent = true })  -- Insert before the selection

-- Prevent Esc from leaving Visual Mode (stay in Visual Mode)
-- vim.keymap.set('v', '<Esc>', '', { noremap= true, silent = true })

-- Custom mappings to enter Insert Mode from Visual Mode
vim.keymap.set('v', 'i', '<Esc>i', { noremap = true, silent = true })  -- Insert before the selection
vim.keymap.set('v', 'a', '<Esc>a', { noremap = true, silent = true })  -- Insert after the selection
vim.keymap.set('v', 'o', '<Esc>o', { noremap = true, silent = true })  -- open after the selection
vim.keymap.set('v', 'r', '<Esc>r', { noremap = true, silent = true })  -- replace the current selection

-- Custom mapping to quit Visual Mode and enter Normal Mode
vim.keymap.set('v', 'q', '<Esc>', { noremap = true, silent = true })
