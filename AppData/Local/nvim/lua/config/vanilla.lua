-- ─────────────────────────────────────
-- Essentials
-- ─────────────────────────────────────


vim.g.mapleader = ' '


-- ─────────────────────────────────────
-- Options
-- ─────────────────────────────────────


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.iminsert = 1
vim.opt.mouse = 'a'
vim.opt.wrap = true
vim.opt.smoothscroll = true
vim.opt.breakindent = true

-- enable lateral motion
vim.opt.whichwrap:append("<>,hl")

-- also configured in .editorconfig
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.smartcase = true

-- search and replace /%s
-- vim.opt.inccommand = "split"

-- save files
vim.opt.swapfile = true
vim.opt.directory = vim.fn.expand("$USERPROFILE/nvimfiles/swap")
-- vim.opt.updatetime = 300

-- better scrolling
vim.opt.scrolloff = 999

-- basic completions
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.complete= {'.', 't', 'i'}
-- vim.opt.complete= {'.', 'w', 'b', 'u', 't', 'i'}

-- status line
vim.o.laststatus = 3
-- vim.o.statusline = "%#StA# %{v:lua.string.upper(mode())} %#StB# %<%f %m%r %#StMid#%= %#StB# %p%% %l:%c %#StA# " .. os.date(" %H:%M ")

-- tabline
vim.opt.showtabline = 0

-- cursor line
vim.opt.cursorline = false

-- colorscheme
vim.opt.termguicolors = false
vim.cmd("colorscheme default")

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- some qol visual enhacements for better clarity
-- vim.opt.list = true
-- vim.opt.listchars = {
--   trail = '·',
--   eol = '↴',
-- }

--terminal options
-- vim.opt.shell = 'powershell'
-- vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
-- vim.opt.shellquote = '"'
-- vim.opt.shellxquote = ''




-- ─────────────────────────────────────
-- Keymaps
-- ─────────────────────────────────────


-- always enter in insert mode
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  command = "startinsert"
})

-- Set qq to quit to normal mode at all times
vim.keymap.set({'i', 'v', 'o'}, 'qq', "<Esc>", {desc = 'Escape to Normal Mode'})
vim.keymap.set('t', 'qq', [[<C-\><C-n>]], {desc = 'Escape to Normal Mode from terminal'})

-- Set ` to quit to normal mode at all times
-- vim.keymap.set({'i', 'v'}, '`', "<Esc>", {desc = 'Escape to Normal Mode'})
-- vim.keymap.set('t', '`', [[<C-\><C-n>]], {desc = 'Escape to Normal Mode from terminal'})

-- Set <M-v> to act as visual block mode
-- vim.keymap.set({'n', 'v'}, '<M-v>', "<C-v>", {desc = 'alt - v for visual block mode'})

-- Set U to act as redo
vim.keymap.set({'n'}, 'U', "<C-r>", {desc = 'U for redo'})

-- map k to act as delete in normal and visual mode, add in motion or other combinations or motions as well if i have missed any
vim.keymap.set({'n', 'v', 'o'}, 'k', 'd', { desc = 'k to kill or delete ' })
vim.keymap.set({'n', 'v', 'o'}, 'kk', 'dd', { desc = 'k to kill or delete' })




-- some navigation improvements in insert mode
vim.keymap.set({'i'}, '<C-t>', '`', {desc = 'control t to act as tab', noremap = true})
vim.keymap.set({'i'}, '<S-Tab>', '<Tab>', {desc = 'control l to act as template literal', noremap = true})
-- option 1 lateral movement with tab
-- vim.keymap.set({'i'}, '`', "<C-o>", {desc = 'Escape to Normal Mode temporarily'})
-- vim.keymap.set({'i'}, '<Tab>', '<C-o>l', {desc = 'move forward by char', noremap = true})
-- vim.keymap.set({'i'}, '<S-Tab>', '<C-o>h', {desc = 'move backward by char', noremap = true})
-- option 2 lateral movement with backtick
vim.keymap.set({'i'}, '<Tab>', '<C-o>', {desc = 'tab for temporary normal mode', noremap = true})
vim.keymap.set({'i'}, '`', '<C-o>h', {desc = 'move forward by char', noremap = true})
vim.keymap.set({'i'}, '~', '<C-o>l', {desc = 'move forward by char', noremap = true})


-- map <BS> to act as s (i.e. substitute with no yank) in normal and visual mode
vim.keymap.set({'n'}, '<BS>', 's', { desc = 'backspace to delete current word and place in insert mode' })
vim.keymap.set({'v'}, '<BS>', '"_d', { desc = 'backspace to remove the selection and not copy it' })

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
vim.keymap.set({'n', 'v', 'o'}, 'S', 'b', { desc = 'Move left by a word up to next white space' })
vim.keymap.set({'n', 'v', 'o'}, 'F', 'e', { desc = 'Move right by a word up to next white space' })

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
-- vim.keymap.set({ 'i' }, '<Tab>', function()
--
--   local line = vim.api.nvim_get_current_line()
--   local col = vim.fn.col('.') - 1
--   local before_cursor = line:sub(1, col)
--   local word = before_cursor:match("[%w_]+$")
--
--   if word then
--     return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)
--   end
--
--   return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
-- end, {
--   expr = true,
--   noremap = true,
--   desc = 'Smart Tab for completion'
-- })
--









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
