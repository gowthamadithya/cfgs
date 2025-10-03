-- Load basic options and keymaps eagerly
--require('config.vanilla')
require('config.helix')
-- require('config.visual')



-- Function to lazy-load the rest of the configuration
local function load_full_config()
  if vim.g.vscode then return end
  if vim.g.full_config_loaded then return end
  vim.g.full_config_loaded = true

  -- require('config.vanillaextras')
  -- require('config.commands')


  vim.opt.termguicolors = true
  -- require('vscodedark').set_highlights()
  require('config.lazy')
  -- vim.cmd("Oil")
  -- require('config.winbar')
  vim.notify("Full config loaded", vim.log.levels.INFO)
end




-- Get the first argument passed to Neovim (if any)
local arg = vim.fn.argv(0)

if arg == "" then
  arg = vim.fn.getcwd()  -- Get the current working directory
end

if vim.fn.isdirectory(arg) == 1 then

  load_full_config()

else
  -- print('is a file')
end

-- to activate any vscode specific settings supported by lazy
if vim.g.vscode then
    -- VSCode extension
    print("this from vscode")
else
    -- ordinary Neovim
end


-- command, keymap to manually trigger full config load
vim.api.nvim_create_user_command('Loadfc', load_full_config, {})
vim.keymap.set('n', '<leader>fc', load_full_config, { desc = 'Load full config' })
