-- Access the Vim variable from Lua
local noext = vim.g.noext == 1

if noext then
  -- Only set keymaps and options
  -- vim options
  require('config.options')

  -- custum keymaps
  require('config.keymaps')

  -- optional some theme
  -- require('vscodedark').setup()

else
  -- vim options
  require('config.options')

  -- custum keymaps
  require('config.keymaps')

  -- clean winbar
  -- require('config.winbar')

  -- plugin manager
  require('config.lazy')

end
