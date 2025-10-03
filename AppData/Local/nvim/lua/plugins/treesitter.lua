-- treesitter for parsing, highlighting, indenting, and AST navigation
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  enabled = true,
  dependencies = {
    "dkendal/nvim-treeclimber",
  },
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "c", "lua", "python", "html", "css", "javascript",
        "typescript", "tsx", "markdown", "markdown_inline", "json",
        "yaml", "csv", "bash"
      },
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = { enable = false },
      textobjects = { enable = true },
    })

    -- Treeclimber setup
    require("nvim-treeclimber").setup({
      highlight = true, -- highlights the selected node
    })

    local opts = { noremap = true, silent = true }

    -- h j k l navigation + selection
    vim.keymap.set({ "n", "x", "o" }, "h", "<Plug>(treeclimber-select-parent)", opts)
    vim.keymap.set({ "n", "x", "o" }, "l", "<Plug>(treeclimber-select-next)", opts)
    vim.keymap.set({ "n", "x", "o" }, "j", "<Plug>(treeclimber-select-previous)", opts)
    vim.keymap.set({ "n", "x", "o" }, "k", "<Plug>(treeclimber-select-shrink)", opts)

    -- Select current node
    vim.keymap.set({ "n", "x", "o" }, "<C-Space>", "<Plug>(treeclimber-select-current-node)", opts)
  end,
}

