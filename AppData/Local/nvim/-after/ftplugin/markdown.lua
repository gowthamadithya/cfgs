-- Set conceal and folding options
vim.opt_local.termguicolors = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
-- vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = "nc"
-- vim.opt_local.foldmethod = "indent"
-- vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.g.markdown_minlines = 100  -- For folding to be more robust
-- vim.g.markdown_enable_folding = 1



vim.opt_local.formatoptions:append("n")  -- Recognize numbered lists
vim.opt_local.formatlistpat = [[^\s*\d\+\.\s\+]]  -- Pattern for list recognition


-- vim.opt_local.showbreak = "↪ "
vim.opt_local.spell = true  -- Enable spell checking
vim.opt_local.spelllang = { 'en_us' }  -- Set spellcheck language
-- vim.opt_local.autoindent = true
-- vim.opt_local.smartindent = true
vim.opt_local.breakindent = true  -- Better wrapped line indentation
-- vim.opt_local.breakindentopt = "shift:3,min:2"
-- vim.opt_local.showbreak = "  "
vim.opt_local.textwidth = 140  -- Limit line width (optional for prose)
vim.opt_local.colorcolumn = "140"  -- Highlight limit (visual cue)

-- vim.opt_local.textwidth = 0      -- Don’t auto-wrap on typing
-- vim.opt_local.colorcolumn = ""   -- No visual column limit

vim.opt_local.cursorline = true  -- Highlight current line

vim.g.markdown_fenced_languages = {
  "python",
  "bash=sh",
  "javascript",
  "js=javascript",
  "typescript",
  "lua",
  "json",
  "html",
  "css",
  "yaml",
  "cpp",
  "c",
}

-- Load colors from vscodedark theme
local colors = require('vscodedark').colors

-- ─────────────────────────────────────
-- 📘 Emphasis Styling
-- ─────────────────────────────────────

-- Bold (Strong, bright white)
vim.api.nvim_set_hl(0, "markdownBold", {
  fg = colors.vscBold,  -- brighter than vscFront
  bold = true,
})

-- Italic (Subtle blue for tone)
vim.api.nvim_set_hl(0, "markdownItalic", {
  fg = colors.vscLightBlue,
  italic = true,
})

-- Bold + Italic (Pop color with strength)
vim.api.nvim_set_hl(0, "markdownBoldItalic", {
  fg = colors.vscYellowOrange,
  bold = true,
  italic = true,
})

-- Conceal delimiters like ** and *
vim.api.nvim_set_hl(0, "markdownBoldDelimiter", { fg = colors.vscGray })
vim.api.nvim_set_hl(0, "markdownItalicDelimiter", { fg = colors.vscGray })

-- ─────────────────────────────────────
-- 🧠 Inline Code and Code Blocks
-- ─────────────────────────────────────

-- Inline code (clean and boxed)
vim.api.nvim_set_hl(0, "markdownCode", {
  fg = colors.vscOrange,
  bg = colors.vscCodeBlock,
  italic = true,
})

vim.api.nvim_set_hl(0, "markdownCodeDelimiter", {
  fg = colors.vscGray,
  bg = colors.vscCodeBlock,
})

-- Fenced code blocks
vim.api.nvim_set_hl(0, "markdownCodeBlock", {
  fg = colors.vscOrange,
  bg = colors.vscFoldBackground,
})


-- ─────────────────────────────────────
-- 📝 Lists
-- ─────────────────────────────────────

vim.api.nvim_set_hl(0, "markdownListMarker", {
  fg = colors.vscBlue,
  bold = true,
})

vim.api.nvim_set_hl(0, "markdownOrderedListMarker", {
  fg = colors.vscBlue,
  bold = true,
})

-- ─────────────────────────────────────
-- 🔗 Links & Quotes
-- ─────────────────────────────────────

vim.api.nvim_set_hl(0, "markdownLinkText", {
  fg = colors.vscLightBlue,
  underline = true,
})

vim.api.nvim_set_hl(0, "markdownUrl", {
  fg = colors.vscBlue,
  underline = true,
})

vim.api.nvim_set_hl(0, "markdownBlockquote", {
  fg = colors.vscGray,
  italic = true,
  bg = "#222222",
})

-- ─────────────────────────────────────
-- 📌 Headings
-- ─────────────────────────────────────

vim.api.nvim_set_hl(0, "markdownHeadingDelimiter", {
  fg = colors.vscBlueGreen,
  underline = true,
})

vim.api.nvim_set_hl(0, "markdownH1", { fg = colors.vscBlueGreen, bold = true, underline = true })
vim.api.nvim_set_hl(0, "markdownH2", { fg = colors.vscBlueGreen, bold = true, underline = true })
vim.api.nvim_set_hl(0, "markdownH3", { fg = colors.vscBlueGreen, bold = true, underline = true })

-- ─────────────────────────────────────
-- ✅ Tasks & Rules
-- ─────────────────────────────────────

vim.api.nvim_set_hl(0, "markdownCheckboxUnchecked", {
  fg = colors.vscBlue,
  bold = true,
})

vim.api.nvim_set_hl(0, "markdownCheckboxChecked", {
  fg = colors.vscBlue,
  bold = true,
})
vim.api.nvim_set_hl(0, "markdownRule", { fg = colors.vscDimHighlight })

-- ─────────────────────────────────────
-- 💬 Callouts
-- ─────────────────────────────────────

vim.api.nvim_set_hl(0, "markdownNote", {
  fg = colors.vscYellow,
  bg = "#333300",
  bold = true,
})

vim.api.nvim_set_hl(0, "markdownWarning", {
  fg = colors.vscRed,
  bg = "#331111",
  bold = true,
})

vim.api.nvim_set_hl(0, "markdownInfo", {
  fg = colors.vscBlue,
  bg = "#112233",
  bold = true,
})




-- require("markdownviz").attach()
-- -- Heading Highlights
-- for i = 1, 6 do
--   vim.api.nvim_set_hl(0, "markdownH" .. i, {
--     fg = "#569CD6",
--     bold = true,
--     underline = i <= 3,
--   })
-- end
--
-- vim.api.nvim_set_hl(0, "markdownListMarker", { fg = "#D16D9E", bold = true })
-- vim.api.nvim_set_hl(0, "markdownCheckboxUnchecked", { fg = "#D16D9E", bold = true })
-- vim.api.nvim_set_hl(0, "markdownCheckboxChecked", { fg = "#808080", italic = true, strikethrough = true })
-- vim.api.nvim_set_hl(0, "markdownRule", { fg = "#4B5263", bold = true })
-- vim.api.nvim_set_hl(0, "markdownBlockquote", { fg = "#9CDCFE", italic = true })
-- vim.api.nvim_set_hl(0, "markdownCodeBlock", { fg = "#CE9178", bg = "#2d2d2d" })
-- vim.api.nvim_set_hl(0, "markdownNote", { fg = "#FFD700", bg = "#333300", bold = true })
-- vim.api.nvim_set_hl(0, "markdownWarning", { fg = "#FF6C6B", bg = "#331111", bold = true })
-- vim.api.nvim_set_hl(0, "markdownInfo", { fg = "#61AFEF", bg = "#112233", bold = true })
--


