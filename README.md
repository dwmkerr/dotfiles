# universal-setup
I keep forgetting how I set up clean machines, IDEs, editors and tools. Here's the definitive list.

## Terminal

- TMux
- Vundle


```bash
# Install TMux
brew install tmux
# sudo apt-get install tmux

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

## Vim

1. Clone the `.vimrc`
2. Install Golang binaries: `GoInstallBinaries`.

## NodeJS

Managed via [NVM](https://github.com/creationix/nvm).

```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
```

## Sublime Text 3

### Standard Configuration

- Oceanic Theme (if you see oceanic, you know it's setup. If not, setup!)
- Exclude node_modules, bower_components and binaries from search index, but still show in the sidebar.
- Ruler at col 80
- Default everything to 4 spaces, no tabs

"binary_file_patterns": [
  "*.jpg", "*.jpeg", "*.png", "*.gif", "*.ttf", "*.tga", "*.dds", "*.ico", "*.eot", "*.pdf", "*.swf", "*.jar", "*.zip",
  "node_modules/**",
  "bower_components/**"
]

Sublime Text > Preferences > General > User

```json
{
	"color_scheme": "Packages/User/SublimeLinter/Oceanic Next (SL).tmTheme",
	"tab_size": 4,
	"translate_tabs_to_spaces": true,
    "rulers": [80],
    "binary_file_patterns": [
      "*.jpg", "*.jpeg", "*.png", "*.gif", "*.ttf", "*.tga", "*.dds", "*.ico", "*.eot", "*.pdf", "*.swf", "*.jar", "*.zip",
      "node_modules/**",
      "bower_components/**"
    ]
}

```

## iTerm2

- [Splits in current working directory](https://coderwall.com/p/9xo7aq/open-up-iterm2-splits-in-current-working-directory)
- https://github.com/mhartington/oceanic-next-iterm

## Project Setup

### NodeJS

- Superagent: for HTTP requests
- Supertest: for testing HTTP requests
- Supertest As Promised: adds promises to Supertest
