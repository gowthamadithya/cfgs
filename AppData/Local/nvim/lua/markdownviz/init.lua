local M = {}
local ns = vim.api.nvim_create_namespace("markdown_virtual_renderer")

local symbols = {
  checkbox_unchecked = "☐",
  checkbox_checked   = "☑",
  bullet             = "◉",
  hr                 = "─",
  quote              = "┃",
}

local function clear_extmarks(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

-- Add virtual symbol with offset
local function add_prefix(bufnr, line, text, hl, col)
  vim.api.nvim_buf_set_extmark(bufnr, ns, line, col or 0, {
    virt_text = { { text, hl } },
    virt_text_pos = "overlay",
    hl_mode = "combine",
  })
end

-- Add entire background highlight for code blocks
local function highlight_line(bufnr, line, hl)
  vim.api.nvim_buf_add_highlight(bufnr, ns, hl, line, 0, -1)
end

-- Main render logic
function M.render()
  local bufnr = vim.api.nvim_get_current_buf()
  clear_extmarks(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local in_code_block = false
  local code_block_lang = ""

  for i, line in ipairs(lines) do
    local indent = line:match("^(%s*)") or ""
    local stripped = line:sub(#indent + 1)

    -- Handle headings
    local hashes, text = line:match("^(#+)%s*(.+)")
    if hashes then
      local level = #hashes
      local hl = "markdownH" .. math.min(level, 6)
      highlight_line(bufnr, i - 1, hl)
    end

    -- Code blocks (```lang)
    if line:match("^%s*```") then
      in_code_block = not in_code_block
      code_block_lang = line:match("^%s*```(%w+)") or ""
      highlight_line(bufnr, i - 1, "markdownCodeBlock")
    elseif in_code_block then
      highlight_line(bufnr, i - 1, "markdownCodeBlock")
    end

    -- Horizontal rule
    if line:match("^%s*([-*_])%1%1+") then
      add_prefix(bufnr, i - 1, symbols.hr:rep(20), "markdownRule")
    end

    -- Blockquote
    if stripped:match("^>%s?") then
      add_prefix(bufnr, i - 1, symbols.quote .. " ", "markdownBlockquote")
    end

    -- Callouts
    if stripped:match("^>%s*%[!NOTE%]") then
      highlight_line(bufnr, i - 1, "markdownNote")
    elseif stripped:match("^>%s*%[!WARNING%]") then
      highlight_line(bufnr, i - 1, "markdownWarning")
    elseif stripped:match("^>%s*%[!TIP%]") then
      highlight_line(bufnr, i - 1, "markdownInfo")
    end

    -- Checkboxes
    if stripped:match("^[-*+]%s%[x%]") then
      add_prefix(bufnr, i - 1, indent .. symbols.checkbox_checked .. "  ", "markdownCheckboxChecked")
    elseif stripped:match("^[-*+]%s%[%s%]") then
      add_prefix(bufnr, i - 1, indent .. symbols.checkbox_unchecked .. "  ", "markdownCheckboxUnchecked")
    end

    -- List bullets
    if stripped:match("^[-*+]%s[^%[]") then
      add_prefix(bufnr, i - 1, indent .. symbols.bullet .. "  ", "markdownListMarker")
    end
  end
end

function M.attach()
  vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "BufWinEnter" }, {
    pattern = "*.md",
    callback = function()
      vim.defer_fn(M.render, 20)
    end,
    group = vim.api.nvim_create_augroup("MarkdownRenderExtmarks", { clear = true }),
  })
end

return M
