# Light Weight Essential setup Neovim Windows

## Dependencies
1. fd
2. fzf(optional)
3. ripgrep

## installation
1. backup current nvim setup - manually copy the folder somewhere OR

```bash
# required
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# optional but recommended
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
```

2. Clone to %USERPROFILE%/AppData/Local/nvim/
3. optional remove .git to make a new repo according to your customization
```bash
Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force
```

