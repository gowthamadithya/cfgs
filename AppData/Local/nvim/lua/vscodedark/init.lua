local hl = vim.api.nvim_set_hl
local M = {}

-- Colors from VSCode Dark, tuned for better contrast
M.colors = {
    vscNone = 'NONE',
    vscFront = '#D4D4D4',
    vscBack = '#1F1F1F',
    vscBold = '#FFFFFF',
    vscCursorDarkDark = '#222222',
    vscCursorLight = '#AEAFAD',
    vscSelection = '#264F78',
    vscLineNumber = '#5A5A5A',
    vscDiffGreenLight = '#4B5632',
    vscDiffRedDark = '#4B1818',
    vscDiffRedLight = '#6F1313',
    vscSearch = '#613315',
    vscSearchCurrent = '#515c6a',
    vscFoldBackground = '#202d39',
    vscCodeBlock = "#2e2e2e",
    vscGray = '#808080',
    vscBlue = '#569CD6',
    vscLightBlue = '#9CDCFE',
    vscGreen = '#6A9955',
    vscBlueGreen = '#4EC9B0',
    vscLightGreen = '#B5CEA8',
    vscRed = '#F44747',
    vscOrange = '#CE9178',
    vscYellow = '#DCDCAA',
    vscPink = '#C586C0',
    vscDimHighlight = '#51504F',
    vscDarkBlue = '#223E55',
    vscYellowOrange = '#D7BA7D',
    vscBlendGray = '#5A5A5A', -- For statusline blending
    -- statusline
    vscStatusLineBg = '#262626',     -- others #2A2A2A, #1F1F1F (Normal bg)
    vscStatusLineNCBg = '#232323',   -- even subtler for inactive
}

-- Theme highlights
M.set_highlights = function(opts)
    opts = opts or { italic_comments = true, underline_links = true }
    local c = M.colors

    -- Core UI
    hl(0, 'Normal', { fg = c.vscFront, bg = c.vscBack })
    hl(0, 'Cursor', { fg = c.vscCursorDarkDark, bg = c.vscCursorLight })
    hl(0, 'CursorLine', { bg = c.vscCursorDarkDark })
    hl(0, 'LineNr', { fg = c.vscLineNumber, bg = c.vscBack })
    hl(0, 'CursorLineNr', { fg = c.vscFront, bg = c.vscBack, bold = true })
    hl(0, 'Visual', { bg = c.vscSelection })
    hl(0, 'MatchParen', { fg = c.vscYellow, bg = c.vscDimHighlight, bold = true })
    hl(0, 'Folded', { bg = c.vscFoldBackground, fg = c.vscGray })
    hl(0, 'Search', { bg = c.vscSearch, fg = c.vscFront })
    hl(0, 'IncSearch', { bg = c.vscSearchCurrent, fg = c.vscFront })
    hl(0, 'NonText', { fg = c.vscLineNumber })
    hl(0, 'Pmenu', { fg = c.vscFront, bg = c.vscDimHighlight })
    hl(0, 'PmenuSel', { fg = c.vscFront, bg = c.vscBlue, bold = true })
    -- statusline things
    hl(0, 'StatusLine', { fg = c.vscFront, bg = c.vscStatusLineBg, bold = true })
    hl(0, 'StatusLineNC', { fg = c.vscGray, bg = c.vscStatusLineNCBg })
    -- hl(0, 'StatusLine', { fg = c.vscFront, bg = c.vscBack, bold = true })
    -- hl(0, 'StatusLineNC', { fg = c.vscGray, bg = c.vscBack })
    hl(0, 'WinSeparator', { fg = c.vscGray, bg = c.vscBack })
    hl(0, 'ErrorMsg', { fg = c.vscRed, bg = c.vscBack, bold = true })
    hl(0, 'WarningMsg', { fg = c.vscYellowOrange, bg = c.vscBack, bold = true })

    -- Syntax
    hl(0, 'Comment', { fg = c.vscGreen, italic = opts.italic_comments })
    hl(0, 'Constant', { fg = c.vscBlue })
    hl(0, 'String', { fg = c.vscOrange })
    hl(0, 'Number', { fg = c.vscLightGreen })
    hl(0, 'Boolean', { fg = c.vscBlue })
    hl(0, 'Identifier', { fg = c.vscLightBlue })
    hl(0, 'Function', { fg = c.vscYellow })
    hl(0, 'Statement', { fg = c.vscPink })
    hl(0, 'Keyword', { fg = c.vscPink })
    hl(0, 'Type', { fg = c.vscBlueGreen })
    hl(0, 'Error', { fg = c.vscRed, undercurl = true, sp = c.vscRed })
    hl(0, 'Todo', { fg = c.vscYellowOrange, bold = true })

    -- Diff
    hl(0, 'DiffAdd', { bg = c.vscDiffGreenLight, fg = c.vscFront })
    hl(0, 'DiffChange', { bg = c.vscDiffRedDark, fg = c.vscFront })
    hl(0, 'DiffDelete', { bg = c.vscDiffRedLight, fg = c.vscFront })
    hl(0, '@diff.plus', { link = 'DiffAdd' })
    hl(0, '@diff.minus', { link = 'DiffDelete' })
    hl(0, '@diff.delta', { link = 'DiffChange' })

    -- Treesitter
    hl(0, '@punctuation.bracket', { fg = c.vscFront })
    hl(0, '@comment', { link = 'Comment' })
    hl(0, '@constant', { fg = c.vscBlue })
    hl(0, '@string', { fg = c.vscOrange })
    hl(0, '@number', { fg = c.vscLightGreen })
    hl(0, '@boolean', { fg = c.vscBlue })
    hl(0, '@variable', { fg = c.vscLightBlue })
    hl(0, '@function', { fg = c.vscYellow })
    hl(0, '@keyword', { fg = c.vscPink })
    hl(0, '@type', { fg = c.vscBlueGreen })
    hl(0, '@attribute', { fg = c.vscYellowOrange, underline = true })
    hl(0, '@property', { fg = c.vscLightBlue })

    -- Python Enhancements
    hl(0, 'pythonStatement', { fg = c.vscPink, bold = true })
    hl(0, 'pythonOperator', { fg = c.vscPink })
    hl(0, 'pythonException', { fg = c.vscRed, bold = true })
    hl(0, 'pythonBuiltinObj', { fg = c.vscBlue })
    hl(0, 'pythonBuiltinType', { fg = c.vscBlueGreen })
    hl(0, 'pythonDecorator', { fg = c.vscYellowOrange, italic = true, underline = true })
    hl(0, '@string.docstring.python', { fg = c.vscGreen, italic = true })
    hl(0, '@constructor.python', { fg = c.vscBlueGreen })
    hl(0, 'pythonClassDef', { fg = c.vscBlueGreen, bold = true })
    hl(0, '@string.special.python', { fg = c.vscOrange, italic = true }) -- f-strings

    -- Web Development (HTML, CSS, JavaScript, TypeScript, React)
    hl(0, 'htmlTag', { fg = c.vscGray })
    hl(0, 'htmlTagName', { fg = c.vscBlue, bold = true })
    hl(0, 'htmlArg', { fg = c.vscLightBlue })
    hl(0, 'cssProp', { fg = c.vscLightBlue })
    hl(0, 'cssAttr', { fg = c.vscOrange })
    hl(0, 'cssTagName', { fg = c.vscYellowOrange, bold = true })
    hl(0, 'jsFuncCall', { fg = c.vscYellow })
    hl(0, 'jsVariableDef', { fg = c.vscLightBlue })
    hl(0, 'jsObjectKey', { fg = c.vscLightBlue, bold = true })
    hl(0, 'jsThis', { fg = c.vscBlue, italic = true })
    hl(0, 'jsAsyncKeyword', { fg = c.vscPink, bold = true })
    hl(0, 'typescriptVariableDeclaration', { fg = c.vscLightBlue })
    hl(0, 'typescriptImport', { fg = c.vscPink, underline = true })
    hl(0, 'typescriptTypeReference', { fg = c.vscBlueGreen })
    hl(0, 'typescriptMember', { fg = c.vscYellow })
    hl(0, 'typescriptJSXTag', { fg = c.vscBlue, bold = true })
    hl(0, 'typescriptJSXAttribute', { fg = c.vscLightBlue })

    -- SQL
    hl(0, 'sqlKeyword', { fg = c.vscPink, bold = true })
    hl(0, 'sqlFunction', { fg = c.vscYellow })
    hl(0, 'sqlOperator', { fg = c.vscPink })
    hl(0, 'sqlString', { fg = c.vscOrange, italic = true })

    -- Markdown
    hl(0, 'markdownHeadingDelimiter', { fg = c.vscBlue, bold = true })
    hl(0, 'markdownCode', { fg = c.vscOrange, bg = c.vscFoldBackground })
    hl(0, 'markdownLinkText', { fg = c.vscLightBlue, underline = opts.underline_links })
    hl(0, 'markdownUrl', { fg = c.vscLightBlue, underline = opts.underline_links })

    -- JSON
    hl(0, 'jsonKeyword', { fg = c.vscLightBlue, bold = true })
    hl(0, 'jsonString', { fg = c.vscOrange })
    hl(0, 'jsonBoolean', { fg = c.vscBlue })

    -- YAML
    hl(0, 'yamlKey', { fg = c.vscBlue, bold = true })
    hl(0, 'yamlConstant', { fg = c.vscBlue })

    -- Git
    hl(0, 'gitcommitSummary', { fg = c.vscPink, bold = true })
    hl(0, 'gitcommitSelectedFile', { fg = c.vscGreen })
    hl(0, 'gitcommitDiscardedFile', { fg = c.vscRed })
end

return M
