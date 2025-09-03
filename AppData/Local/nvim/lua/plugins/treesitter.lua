-- treesitter for error recovery, language parsing, highlighting, indenting

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  enabled = true,
  config = function ()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "lua", "python", "html", "css", "javascript", "typescript", "tsx", "markdown", "markdown_inline", "json", "yaml", "csv", "bash" },
      sync_install = false,
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
    })
  end
}

-- command to change builtin methods to different color
-- vim.cmd [[hi @function.built_in guifg = yellow]]
