-- ─────────────────────────────────────
-- Essentials
-- ─────────────────────────────────────


vim.g.mapleader = ' '


-- ─────────────────────────────────────
-- Options
-- ─────────────────────────────────────

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.mouse = 'a'
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.smartcase = true

# saving files
vim.opt.swapfile = true
vim.opt.directory = vim.fn.expand("$USERPROFILE/nvimfiles/swap")

-- better scrolling
vim.opt.scrolloff = 999

-- basic completions
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.complete= {'.', 't', 'i'}
-- vim.opt.complete= {'.', 'w', 'b', 'u', 't', 'i'}

-- status line
vim.o.laststatus = 3

-- tabline
vim.opt.showtabline = 0

-- cursor line
vim.opt.cursorline = false

-- colorscheme
vim.opt.termguicolors = false
vim.cmd("colorscheme default")





-- ─────────────────────────────────────
-- Keymaps
-- ─────────────────────────────────────


-- Set qq to quit to normal mode at all times
vim.keymap.set({'i', 'v', 'o'}, 'qq', "<Esc>", {desc = 'Escape to Normal Mode'})
vim.keymap.set('t', 'qq', [[<C-\><C-n>]], {desc = 'Escape to Normal Mode from terminal'})

-- Set ` to quit to normal mode at all times
-- vim.keymap.set({'i', 'v'}, '`', "<Esc>", {desc = 'Escape to Normal Mode'})
-- vim.keymap.set('t', '`', [[<C-\><C-n>]], {desc = 'Escape to Normal Mode from terminal'})

-- Set <M-v> to act as visual block mode
vim.keymap.set({'n', 'v'}, '<M-v>', "<C-v>", {desc = 'alt - v for visual block mode'})

-- map k to act as delete in normal and visual mode, add in motion or other combinations or motions as well if i have missed any
vim.keymap.set({'n', 'v', 'o'}, 'k', 'd', { desc = 'k to kill or delete ' })
vim.keymap.set({'n', 'v', 'o'}, 'kk', 'dd', { desc = 'k to kill or delete' })

-- map <BS> to act as s (i.e. substitute with no yank) in normal and visual mode
vim.keymap.set({'n'}, '<BS>', 's', { desc = 'backspace to delete current word and place in insert mode' })
vim.keymap.set({'v'}, '<BS>', '"_s', { desc = 'backspace to remove the selection and not copy it' })

-- map j to act f (i.e. jump to char) in normal and visual mode, add in motion or other combinations or motions as well if i have missed any
vim.keymap.set({'n', 'v', 'o'}, 'j', 'f', { desc = 'j to jump to the first found char' })

-- map e, s, d, f to navigate up, down, left, right
vim.keymap.set({'n', 'v', 'o'}, 'e', 'gk', { desc = 'Move up by visual line' })
vim.keymap.set({'n', 'v', 'o'}, 'd', 'gj', { desc = 'Move down by visaul line' })
vim.keymap.set({'n', 'v', 'o'}, 's', 'h', { desc = 'Move left' })
vim.keymap.set({'n', 'v', 'o'}, 'f', 'l', { desc = 'Move right' })

-- map E, D to half page Up, Down. <C-d>, <C-u> moves half page up down
vim.keymap.set({'n', 'v', 'o'}, 'E', '10gk', { desc = 'Move cursor to the top of the screen' })
vim.keymap.set({'n', 'v', 'o'}, 'D', '10gj', { desc = 'Move cursor to the bottom of the screen' })

-- some scrolling improvements, actually better with scrolloff == 999
-- vim.keymap.set({"n"}, "<C-d>", "<C-d>zz") -- Scroll down and center
-- vim.keymap.set({"n"}, "<C-u>", "<C-u>zz") -- Scroll up and center
-- vim.keymap.set({"n"}, "n", "nzzzv") -- Jump to next match and center
-- vim.keymap.set({"n"}, "N", "Nzzzv") -- Jump to previous match and center

-- map S, F to move by words
vim.keymap.set({'n', 'v', 'o'}, 'S', 'B', { desc = 'Move left by a word up to next white space' })
vim.keymap.set({'n', 'v', 'o'}, 'F', 'E', { desc = 'Move right by a word up to next white space' })

-- map h, l to move by start, end of the horizontal line. H, M, L moves cursor to top, Middle, bot of current page
vim.keymap.set({'n', 'v', 'o'}, 'h', '^', { desc = 'first non blank charecter' })
vim.keymap.set({'n', 'v', 'o'}, 'l', '$', { desc = 'End of the line' })

-- map +, - to increment or decrement arithematics
vim.keymap.set({'v'}, '+', 'g<C-a>', { desc = 'smart increment' })
vim.keymap.set({'v'}, '-', 'g<C-x>', { desc = 'smart decrement' })
vim.keymap.set({'n'}, '+', '<C-a>', { desc = 'increment by 1' })
vim.keymap.set({'n'}, '-', '<C-x>', { desc = 'decrement by 1' })

-- map b to none as its covered by h
vim.keymap.set({'n', 'v', 'o'}, 'b', '<nop>', { desc = 'left for future use' })
vim.keymap.set({'n', 'v', 'o'}, 'B', '<nop>', { desc = 'left for future use' })

-- disable macros and ex mode temporarily
vim.keymap.set({'n', 'v', 'o'}, 'q', '<nop>', { desc = 'left for future use' })
vim.keymap.set({'n', 'v', 'o'}, 'Q', '<nop>', { desc = 'left for future use' })

-- smart tab for completion
vim.keymap.set({ 'i' }, '<Tab>', function()

  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col('.') - 1
  local before_cursor = line:sub(1, col)
  local word = before_cursor:match("[%w_]+$")

  if word then
    return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)
  end

  return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
end, {
  expr = true,
  noremap = true,
  desc = 'Smart Tab for completion'
})










-- ─────────────────────────────────────
-- additonals
-- ─────────────────────────────────────

-- some useful command line keybinds
-- <C-r>+ paste from system keyboard to command line
-- <C-f> to maximize cmd line window and open history
-- :r !command - reads the command to the current buffer, :let @+ = !command - command to system clipboard
-- :let @+ = system("command") for shell commands, :let @+ = luaeval("command") for nvim state using lua - output to +register
-- ex: let @+ =luaeval("vim.inspect(require('lspconfig').util.available_servers())")
-- :redir @+ | !ls | redir END - redirects the command output to +register(system clipboard)


-- some useful control modifier keybinds
-- <C-r>reg_name pastes the text from that register
-- since . register holds the most recent insert edit(<C-r>.) it can also via <C-a>
-- <C-x> acts as special insert completion mode, <C-x><C-]> for tags
-- <C-]> to jump to definition, <C-o>, <C-i> for navigating jumplist
-- jumplist is stack with all the jumps, <C-t> to pop the last jump
-- ./somefile.py, place cursor under file and 'gf' to visit file, <C-0>, <C-i> works here too
-- <C-u>, <C-d> scrolls up and down half a page, <C-e>, <C-y> scrolls a line up and down
-- <C-f>, <C-b> scrolls full page up and down

-- some general useful keymaps
-- gt in normal mode switches through tabs

-- ─────────────────────────────────────
-- Leader keymaps
-- ─────────────────────────────────────

-- Save and Quit with leader s, q
vim.keymap.set('n', '<leader>s', '<cmd>write<cr>', {desc = 'Save'})
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>', {desc = 'Quit'})


-- lua execution or mapping source %
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<cr>', {desc = 'execute'})
vim.keymap.set('n', '<leader>x', ':.Lua<cr>', {desc = 'execute'})
vim.keymap.set('v', '<leader>x', ':Lua<cr>', {desc = 'execute'})

-- Switch between windows with leader w
vim.keymap.set('n', '<leader>n', '<C-w>w', {desc = 'Switch between windows'})
vim.keymap.set('n', '<leader>m', '<C-w>T', {desc = 'Maximize current window'})

-- Switch between buffers with leader bb, leader h for prev buffer, leader l for next buffer
vim.keymap.set('n', '<leader>bb', '<cmd>bnext<cr>', {desc = 'Next buffer'})
vim.keymap.set('n', '<leader>h', '<cmd>bprev<cr>', {desc = 'Previous buffer'})
vim.keymap.set('n', '<leader>l', '<cmd>bnext<cr>', {desc = 'Next buffer'})
