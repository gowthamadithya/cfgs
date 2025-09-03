-- oil for file tree

return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  opts = function()
    local oil_actions = require("oil.actions")
    local oil = require("oil")

    local oil_vnew_open = function()

      vim.cmd("topleft vsplit")
      vim.cmd("vertical resize 40")
      vim.wo.winfixwidth = true

      -- Open Oil, then enforce winfixwidth again in case buffer changes
      oil.open()
    end

    local get_oil_ftree = function()
      local buf_id = nil
      local list_wins = vim.api.nvim_list_wins()

      -- Check if Oil is already open
      for _, win in ipairs(list_wins) do
        buf = vim.api.nvim_win_get_buf(win)
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        if filetype == "oil" then
          if #list_wins > 1 then
            buf_id = buf
            vim.api.nvim_set_current_win(win)
            vim.wo.winfixwidth = true
            vim.api.nvim_win_set_width(win, 40)
          end
        end
        return buf_id

      end
    end

    vim.keymap.set("n", "<leader>ft", function()
        oil_vnew_open()
    end, { desc = "Toggle Oil file explorer in left split" })

    return {
      default_file_explorer = true,
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = {
          callback = function()
            local entry = oil.get_cursor_entry()
            if not entry or not entry.name then
              return
            end

            local full_path = oil.get_current_dir() .. "/" .. entry.name

            if entry.type == "directory" then
              -- Stay in Oil buffer and navigate into the directory
              oil.select({ path = full_path, close = false })
            else

              if get_oil_ftree() then

                -- Move to the right split (oil always defaults to left)
                vim.cmd("wincmd l")
                -- Edit the file in the right window
                vim.cmd("edit " .. vim.fn.fnameescape(full_path))
              else
                oil.select()

              end
            end
          end,
          desc = "Open file in new tab on the right or enter directory",
        },
        -- ["<C-f>"] = { function() get_oil_ftree() end },
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<Tab>"] = {
          callback = function()
            local entry = oil.get_cursor_entry()
            if not entry or not entry.name then
              return
            end

            local full_path = oil.get_current_dir() .. "/" .. entry.name

            if entry.type == "directory" then
              -- Stay in Oil buffer and navigate into the directory
              oil.select({ path = full_path, close = false })
            else
              -- Open file in a new tab
              vim.cmd("tabedit " .. vim.fn.fnameescape(full_path))

              -- Move the new tab to the right of the current one
              local current_tab = vim.fn.tabpagenr()
              vim.cmd("tabmove " .. current_tab)
            end
          end,
          desc = "Open file in new tab on the right or enter directory",
        },

        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
        ["<C-p>"] = "actions.preview",

        ["<leader>q"] = {
          callback = function()
            local oil = require("oil")
            oil.close()             -- Closes the Oil buffer

            if vim.fn.winnr('$') == 1 then
              vim.cmd("q")  -- quit
            else
              vim.cmd("wincmd c")     -- Closes the split (window)
            end
          end,
          desc = "Close Oil and its window cleanly",
          mode = "n",
        },

        ["<C-l>"] = "actions.refresh",
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      }
    }
  end,
}
