-- lsp for quick fixes and error checks, lint, auto-completion

-- diagnostics enable
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

return {
  "neovim/nvim-lspconfig",
  enabled = false,
  dependencies = {
    'saghen/blink.cmp'
  },


  -- using `opts` for defining servers
  opts = {
    servers = {
      -- pylsp = {
      --   settings = {
      --     pylsp = {
      --       -- add or toggle new plugins
      --       plugins = {
      --         -- Formatter
      --         black = { enabled = true }, -- Modern formatter
      --         autopep8 = { enabled = false },
      --         yapf = { enabled = false },
      --
      --         -- Linting
      --         pyflakes = { enabled = true }, -- Fast, simple error checker
      --         pycodestyle = { enabled = true }, -- Enforce PEP8 (configure to match black)
      --         pylint = { enabled = false }, -- Too heavy, redundant with pyflakes/mypy
      --         mccabe = { enabled = true }, -- Complexity checker
      --
      --         -- Type checker
      --         pylsp_mypy = { enabled = true }, -- Type-aware error detection
      --
      --         -- Code actions
      --         pylsp_rope = { enabled = true }, -- Rename, extract, etc.
      --         pyls_isort = { enabled = true }, -- Auto-sort imports
      --       }
      --     }
      --   }
      -- },

      pyright = {
        root_dir = vim.loop.cwd(),
      },

      ts_ls = {
        -- cmd = { "typescript-language-server", "--stdio" },
        -- filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        -- root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
        root_dir = vim.loop.cwd(),
        on_attach = function(client, bufnr)
          -- Optional: disable formatting if using prettier or null-ls
          client.server_capabilities.documentFormattingProvider = false

          -- Keybinds (optional)
          -- local function buf_map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
          -- buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })
          -- buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap=true, silent=true })
        end,
      },
    }
  },

  config = function(_, opts)
    local lspconfig = require('lspconfig')
    for server, config in pairs(opts.servers) do
      -- passing config.capabilities to blink.cmp merges with the capabilities in your
      -- `opts[server].capabilities, if you've defined it
      config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
      lspconfig[server].setup(config)
    end


    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('my.lsp', {}),
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if not client then return end
        if client:supports_method('textDocument/implementation') then
          -- Create a keymap for vim.lsp.buf.implementation ...
        end

        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        if client:supports_method('textDocument/completion') then
          -- Optional: trigger autocompletion on EVERY keypress. May be slow!
          -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
          -- client.server_capabilities.completionProvider.triggerCharacters = chars

          -- vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
        end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
          and client:supports_method('textDocument/formatting') then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
            end,
          })
        end
      end,
    })
  end
}


--[[ 🌟 Neovim LSP Defaults – from :help lsp

  When Neovim's built-in LSP client attaches to a buffer, it automatically enables
  a set of helpful features and keymaps (if supported by the language server):

  📦 Buffer-local options:
  - 'omnifunc'   → Enables manual LSP completion with <C-x><C-o> in Insert mode.
  - 'tagfunc'    → Powers go-to-definition using <C-]>, :tjump, etc.
  - 'formatexpr' → Enables smart formatting with gq (if the server supports it).

  🗺️ Key mappings (if not already set by you or plugins):
  - K        → Show hover documentation.
  - grr      → List references.
  - grn      → Rename symbol.
  - gra      → Code actions (also works in Visual mode).
  - gri      → Go to implementation.
  - gO       → Document symbols.
  - <C-S>    → Signature help (in Insert mode).

  ⚙️ Customization Tip:
  To disable or override any of these defaults (like removing `K` for hover),
  use the LspAttach autocommand:

  ```lua
  vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
  vim.bo[args.buf].formatexpr = nil   -- Disable formatting with gq
  vim.bo[args.buf].omnifunc = nil     -- Disable omni-completion
  vim.keymap.del('n', 'K', { buffer = args.buf }) -- Unmap hover doc
  end,
  })
  ]]
