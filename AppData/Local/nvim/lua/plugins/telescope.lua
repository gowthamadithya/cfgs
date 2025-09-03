-- telescope for fuzzy finding files and live grep
return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8', -- branch = '0.1.x',
  enabled = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
  },
  config = function()
    local actions = require("telescope.actions")
    require('telescope').setup({
      defaults = {
        mappings = {
          -- insert mode mappings
          i = {
            ["<C-h>"] = "which_key",
          },
          -- normal mode mappings
          n = {
            ["e"] = actions.move_selection_previous,
            ["d"] = actions.move_selection_next,
            ["<leader>q"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          -- theme = 'dropdown',
          theme = 'ivy'
        }
      },
      extensions = {
        -- fzf = {}
      },
    })

    -- require('telescope').load_extension('fzf')

    vim.keymap.set({'n'}, '<leader>fh', require('telescope.builtin').help_tags)
    vim.keymap.set({'n'}, '<leader>fd', require('telescope.builtin').find_files)
    vim.keymap.set({'n'}, '<leader>en', function() require('telescope.builtin').find_files{cwd = vim.fn.stdpath('config')} end)

    require('ts_helper.multigrep').setup()
  end
}
