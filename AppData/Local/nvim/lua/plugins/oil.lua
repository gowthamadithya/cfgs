-- oil.nvim as file tree
return {
  "stevearc/oil.nvim",
  opts = function()

    local oil = require("oil")

    -- disable update preview from oil.select
    local orig_selct = package.loaded["oil"].select
    package.loaded["oil"].select = function(opts, callback)
      local cache = require("oil.cache")
      local config = require("oil.config")
      local constants = require("oil.constants")
      local util = require("oil.util")
      local FIELD_META = constants.FIELD_META
      opts = vim.tbl_extend("keep", opts or {}, {})

      local function finish(err)
        if err then
          vim.notify(err, vim.log.levels.ERROR)
        end
        if callback then
          callback(err)
        end
      end
      if not opts.split and (opts.horizontal or opts.vertical) then
        if opts.horizontal then
          opts.split = vim.o.splitbelow and "belowright" or "aboveleft"
        else
          opts.split = vim.o.splitright and "belowright" or "aboveleft"
        end
      end
      if opts.tab and opts.split then
        return finish("Cannot use split=true when tab = true")
      end
      local adapter = util.get_adapter(0)
      if not adapter then
        return finish("Not an oil buffer")
      end

      local visual_range = util.get_visual_range()

      ---@type oil.Entry[]
      local entries = {}
      if visual_range then
        for i = visual_range.start_lnum, visual_range.end_lnum do
          local entry = oil.get_entry_on_line(0, i)
          if entry then
            table.insert(entries, entry)
          end
        end
      else
        local entry = oil.get_cursor_entry()
        if entry then
          table.insert(entries, entry)
        end
      end
      if vim.tbl_isempty(entries) then
        return finish("Could not find entry under cursor")
      end

      -- Check if any of these entries are moved from their original location
      local bufname = vim.api.nvim_buf_get_name(0)
      local any_moved = false
      for _, entry in ipairs(entries) do
        -- Ignore entries with ID 0 (typically the "../" entry)
        if entry.id ~= 0 then
          local is_new_entry = entry.id == nil
          local is_moved_from_dir = entry.id and cache.get_parent_url(entry.id) ~= bufname
          local is_renamed = entry.parsed_name ~= entry.name
          local internal_entry = entry.id and cache.get_entry_by_id(entry.id)
          if internal_entry then
            local meta = internal_entry[FIELD_META]
            if meta and meta.display_name then
              is_renamed = entry.parsed_name ~= meta.display_name
            end
          end
          if is_new_entry or is_moved_from_dir or is_renamed then
            any_moved = true
            break
          end
        end
      end
      if any_moved and config.prompt_save_on_select_new_entry then
        local ok, choice = pcall(vim.fn.confirm, "Save changes?", "Yes\nNo", 1)
        if not ok then
          return finish()
        elseif choice == 1 then
          oil.save()
          return finish()
        end
      end

      local prev_win = vim.api.nvim_get_current_win()
      local oil_bufnr = vim.api.nvim_get_current_buf()

      -- Async iter over entries so we can normalize the url before opening
      local i = 1
      local function open_next_entry(cb)
        local entry = entries[i]
        i = i + 1
        if not entry then
          return cb()
        end
        if util.is_directory(entry) then
          -- If this is a new directory BUT we think we already have an entry with this name, disallow
          -- entry. This prevents the case of MOVE /foo -> /bar + CREATE /foo.
          -- If you enter the new /foo, it will show the contents of the old /foo.
          if not entry.id and cache.list_url(bufname)[entry.name] then
            return cb("Please save changes before entering new directory")
          end
        else
          -- Close floating window before opening a file
          if vim.w.is_oil_win then
            oil.close()
          end
        end

        -- Normalize the url before opening to prevent needing to rename them inside the BufReadCmd
        -- Renaming buffers during opening can lead to missed autocmds
        util.get_edit_path(oil_bufnr, entry, function(normalized_url)
          local mods = {
            vertical = opts.vertical,
            horizontal = opts.horizontal,
            split = opts.split,
            keepalt = false,
          }
          local filebufnr = vim.fn.bufadd(normalized_url)
          local entry_is_file = not vim.endswith(normalized_url, "/")

          -- The :buffer command doesn't set buflisted=true
          -- So do that for normal files or for oil dirs if config set buflisted=true
          if entry_is_file or config.buf_options.buflisted then
            vim.bo[filebufnr].buflisted = true
          end

          local cmd = "buffer"
          if opts.tab then
            vim.cmd.tabnew({ mods = mods })
          elseif opts.split then
            cmd = "sbuffer"
          end
          ---@diagnostic disable-next-line: param-type-mismatch
          local ok, err = pcall(vim.cmd, {
            cmd = cmd,
            args = { filebufnr },
            mods = mods,
          })
          -- Ignore swapfile errors
          if not ok and err and not err:match("^Vim:E325:") then
            vim.api.nvim_echo({ { err, "Error" } }, true, {})
          end

          open_next_entry(cb)
        end)
      end

      open_next_entry(function(err)
        if err then
          return finish(err)
        end
        if
          opts.close
          and vim.api.nvim_win_is_valid(prev_win)
          and prev_win ~= vim.api.nvim_get_current_win()
        then
          vim.api.nvim_win_call(prev_win, function()
            oil.close()
          end)
        end

        -- disable update preview
        -- update_preview_window()

        finish()
      end)
    end

    -- Override open_preview to block during directories
    local orig_open_preview = package.loaded["oil"].open_preview
    package.loaded["oil"].open_preview = function(opts)
      local entry = oil.get_cursor_entry()
      if (entry and entry.type == "directory") then
        return
      end
      orig_open_preview(opts)
    end

    return {
      default_file_explorer = true,
      show_parent_dir = true,

      preview_win = {
        update_on_cursor_moved = false,
        preview_method = "load",
        disable_preview = function(filename)
          return false
        end,
        win_options = {},
      },

      vim.keymap.set({ "n" }, "<leader>ft", function()
        vim.cmd("Oil")
      end, {}),

      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },

        ["<CR>"] = {
          desc = "Preview file or open directory",
          callback = function()
            local entry = oil.get_cursor_entry()
            if not entry then return end

            local util = require("oil.util")
            local winid = util.get_preview_win()

            if entry.type == "directory" then
              oil.select({ close = false })
              return
            end

            if winid and vim.api.nvim_win_is_valid(winid) then
              local current_entry_id = vim.w[winid].oil_entry_id
              if current_entry_id == entry.id then
                vim.api.nvim_set_current_win(winid)
                return
              end
            end

            oil.open_preview({
              vertical = true,
              split = "belowright",
            })
          end,
        },


        ["<BS>"] = {
          desc = "Go to parent directory",
          mode = "n",
          callback = function()
            local actions = require("oil.actions")
            actions.parent.callback()
          end,
        },

        ["<Tab>"] = {
          callback = function()
            local entry = oil.get_cursor_entry()
            if not entry or not entry.name then return end

            local full_path = oil.get_current_dir() .. "/" .. entry.name
            if entry.type == "directory" then
              oil.select({ path = full_path, close = false })
            else
              vim.cmd("tabedit " .. vim.fn.fnameescape(full_path))
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
              oil.set_columns({ "icon", "permissions", "size", "mtime" })
            else
              oil.set_columns({ "icon" })
            end
          end,
        },

        ["<leader>q"] = {
          desc = "Close Oil and its window cleanly",
          callback = function()
            oil.close()
            if vim.fn.winnr('$') == 1 then
              vim.cmd("q")
            else
              vim.cmd("wincmd c")
            end
          end,
          mode = "n",
        },

        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-l>"] = "actions.refresh",
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },

      },
    }
  end,
}
