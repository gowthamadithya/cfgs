

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },


  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto', -- respects your current colorscheme
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = ''},
      globalstatus = true,
    },

    sections = {
      -- LEFT SIDE
      lualine_a = {
        { 'mode', icon = '', fmt = string.upper }, -- MODE in caps
      },

      lualine_b = {
        {
          function()
            local cwd = vim.fn.getcwd()
            return ' ' .. vim.fn.fnamemodify(cwd, ':t')
          end,
          color = { gui = 'bold' },
        },
      },

      lualine_c = {
        {
          'diagnostics',
          sources = { 'nvim_lsp' },
          sections = { 'error', 'warn', 'info' },
          symbols = {
            error = ' ',
            warn  = ' ',
            info  = ' ',
            -- hint  = ' ',
          },
          update_in_insert = true,
          always_visible = true,
        },
        {
          'filename',
          path = 0, -- file name only
          symbols = {
            modified = ' ●',
            readonly = ' 🔒',
            unnamed = '[No Name]',
            newfile = ' ✚',
          },
          color = function()
            if vim.bo.modified then
              return { fg = "#fab387", gui = "bold" }
            end
          end,
        },
        -- display lsp servers if any
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return '' end -- no output if none

            local names = {}
            for _, client in ipairs(clients) do
              table.insert(names, client.name)
            end
            return '[' .. table.concat(names, ', ') .. ']'
          end,
        },
      },

      -- RIGHT SIDE
      lualine_x = {
        -- Git blame (truncated)
        {
          function()
            local max_len = 50
            if package.loaded.gitblame and require('gitblame').is_blame_text_available() then
              local text = require('gitblame').get_current_blame_text() or ''
              return (#text > max_len) and (text:sub(1, max_len - 1) .. '…') or text
            end
            return ''
          end,
          cond = function()
            return package.loaded.gitblame and require('gitblame').is_blame_text_available()
          end,
          color = { fg = "#888888", gui = "italic" },
        },

        -- Git diff
        {
          'diff',
          symbols = { added = ' ', modified = ' ', removed = ' ' },
        },

        -- Git branch
        {
          'branch',
          icon = '',
        },
      },

      lualine_y = {
        -- 'progress',
        'location',
      },

      lualine_z = {
        {
          function()
            return os.date('%H:%M')
          end,
        },
      },
    },

    -- Inactive windows
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          'filename',
          path = 1, -- relative path
        },
      },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },

    extensions = {},
  }
}
