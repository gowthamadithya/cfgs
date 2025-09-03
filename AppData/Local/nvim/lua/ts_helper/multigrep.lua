local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local conf = require 'telescope.config'.values

local M = {}


local multi_grep = function(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job{
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local bits = vim.split(prompt, '%s%s')
      local args = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }

      if bits[1] then
        table.insert(args, '-e')
        table.insert(args, bits[1])
      end

      if bits[2] and string.sub(bits[2], 1, 1) == '.' then
        table.insert(args, '-g')
        table.insert(args, '*' .. bits[2])
      elseif bits[2] then
        table.insert(args, '-e')
        table.insert(args, bits[2])
      end

      --[[ if bits[1] and string.sub(bits[1], 1, 1) == '.' then
        table.insert(args, '-g')
        table.insert(args, '*' .. bits[1])

        if bits[2] then
          table.insert(args, '-e')
          table.insert(args, bits[2])
        end
      else
        table.insert(args, '-e')
        table.insert(args, bits[1])
      end ]]

      return args
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = cwd,
  }

  pickers.new(opts, {
    debounce = 100,
    prompt_title = 'live grep',
    finder = finder,
    previewer = conf.grep_previewer(opts),
    sorter = require("telescope.sorters").empty(),
  }):find()

end

-- multi_grep()

M.setup = function()
  vim.keymap.set({'n'}, "<leader>fg", multi_grep, {})
end

return M
