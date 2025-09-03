
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("MinimalWinbar", { clear = true }),
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype

    -- ❗ Skip floating windows
    local is_floating = function(win)
      local cfg = vim.api.nvim_win_get_config(win)
      return cfg.relative ~= ""
    end
    if is_floating(0) then
      vim.wo.winbar = ""
      return
    end

    local filename = vim.fn.expand("%:t")
    local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
    local winbar = ""

    local exclude = {
      "NvimTree", "TelescopePrompt", "help", "dashboard", "lazy", "alpha",
    }

    if ft == "oil" then
      local cwd = vim.fn.getcwd()
      winbar = "󰉋  " .. vim.fn.fnamemodify(cwd, ":~")
      vim.wo.winbar = winbar
      return
    end

    for _, f in ipairs(exclude) do
      if ft == f then
        vim.wo.winbar = ""
        return
      end
    end

    local icon = ""
    local devicons = require("nvim-web-devicons")
    local ext = vim.fn.expand("%:e")
    local icon_char, _ = devicons.get_icon(filename, ext, { default = true })
    if icon_char then
      icon = icon_char .. " "
    end

    winbar = "%#WinBar#" .. icon .. filepath
    vim.wo.winbar = winbar
  end,
})
