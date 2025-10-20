-- material theme
return {
  'marko-cerovac/material.nvim',
  priority = 1000, -- Ensures theme loads early
  config = function()
    require('material').setup({
      contrast = {
        terminal = false,
        sidebars = false,
        floating_windows = false,
        cursor_line = false,
        lsp_virtual_text = false,
        non_current_windows = false,
        filetypes = {},
      },

      styles = {
        comments = {},
        strings = {},
        keywords = {},
        functions = {},
        variables = {},
        operators = {},
        types = {},
      },

      plugins = {
        -- uncomment the ones you use
        "nvim-notify",
        "telescope",
        "nvim-cmp",
      },

      disable = {
        colored_cursor = false,
        borders = false,
        background = false,
        term_colors = false,
        eob_lines = false,
      },

      high_visibility = {
        lighter = false,
        darker = false,
      },

      lualine_style = "default",
      async_loading = true,
      custom_colors = nil,
      custom_highlights = {},
    })

    -- Set the colorscheme
    vim.cmd("colorscheme material")
  end,
}

