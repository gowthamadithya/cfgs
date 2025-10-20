--- hop just like easy motion
return {
  'smoka7/hop.nvim',
  version = "*",
  opts = {
    keys = 'etovxqpdygfblzhckisuran',  -- Customize the keys for Hop
  },

  config = function()
    local hop = require('hop')
    local util = require('config.util').select
    local helpers = require('config.util').helpers
    local treeclimber = require("nvim-treeclimber")


    -- Initialize hop.nvim with your desired configuration
    hop.setup({
      keys = 'etovxqpdygfblzhckisuran',  -- Customize the keys for Hop (if different from opts)
      case_insensitive = true,          -- Makes Hop case insensitive
      multi_windows = true,             -- Enable Hop across multiple windows
      jump_on_partial_key = false,      -- Only jump when the full key sequence is matched
    })

    -- Map the 't' key to Hop's camelcase navigation for selection
    vim.keymap.set({'n', 'o'}, 't', function()
      hop.hint_camel_case()
      -- helpers.feedkeys('<Esc>v' .. '<Plug>(treeclimber-select-parent)')
    end, {noremap = true, silent = true, desc = 'Jump to the matched word'})

    -- Map the 'T' key to Hop's camelcase navigation for extending selection
    vim.keymap.set('n', 'T', function()
      -- Hop to the next camelcase word

      vim.api.nvim_feedkeys('v', 'n', true)
      hop.hint_camel_case()


    end,{noremap = true, silent = true, desc ='Extend to the matched word'})

    -- Optional: Override normal mode behavior for 't' with a simple fallback (using 'f' in this case)
    -- vim.keymap.set('o', 't', 'f', { silent = true, desc = 'Blip to the matched char' })
  end,
}






