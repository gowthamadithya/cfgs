" ~/.config/nvim/after/syntax/markdown.vim

" custum ones



" Nested unordered lists (supports -, *, +)
syntax match markdownListMarker /^\s\{0,8}[-*+]\s/ containedin=ALL
syntax match markdownListMarker /^\s\{4,12}[-*+]\s/ containedin=ALL
syntax match markdownListMarker /^\s\{8,20}[-*+]\s/ containedin=ALL

" Nested ordered lists (1. 2. 3.)
syntax match markdownOrderedListMarker /^\s*\d\+\.\s/ containedin=ALL
highlight default link markdownListMarker Identifier
highlight default link markdownOrderedListMarker Identifier
