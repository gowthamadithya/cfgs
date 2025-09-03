-- auto command to highlight copied selection
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'highlight the copied selection',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {clear = true}),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- auto command for terminal mode
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'clean terminal experience inside neovim',
  group = vim.api.nvim_create_augroup('clean-term-open', {clear = true}),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    -- vim.opt.signcolumn = "no"
    -- vim.opt.statuscolumn = ""
    -- vim.opt.statusline = ""
    -- vim.opt.laststatus = 0
    -- vim.opt.cursorline = false
    -- vim.opt.cursorcolumn = false
  end,
})

-- small terminal to open with leader st
local job_id = nil
vim.keymap.set({'n'}, '<leader>st', function()
  -- vim.cmd.vnew()
  vim.cmd("startinsert")
  vim.cmd('botright split')
  vim.cmd("term powershell -NoLogo -NoProfile")
  -- vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")
  vim.api.nvim_win_set_height(0, 10)
  -- get the job id of this terminal buffer
  job_id = vim.bo.channel
end)

-- leader dev to run npm run dev etc
vim.keymap.set({'n'}, '<leader>dev', function()
  -- "" at end for new line in term
  vim.fn.chansend(job_id, {"dir", ""})
end)

