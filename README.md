# dotfiles

I keep forgetting how I set up clean machines, IDEs, editors and tools. Here's the definitive list.

## Cheat Sheet - TMux

- Ctrl+B / Ctrl+S - Save Tmux Session
- Ctrl+B / Ctrl+R - Restore Tmux Session
- Ctrl+h/j/k/l - Navigate splits (vim aware)
- Ctrl+/ - Last split
- Ctrl+B h - Move window left
- Ctrl+B l - Move window right

## Cheat Sheet - Vim

- `[<Space>` - blank line above
- `]<Space>` - blank line below
- `sj` - Splitjoin down (i.e. split a line downwards).
- `sk` - Splitjoin up (i.e. join a line upwards).
- `<leader>r` - Open current file in NERDTree.
- `<leader>w` - Write buffer.
- `<leader>\` - Open buffer in new tab.
- `<leader>d` - Open word under cursor in Dash.
- `<leader>t` - Show current buffer in NERDTree.


## Clean Mac

Config: No permenently docked items. Small dock bar. Tap to click.

1. [Google Chrome](https://chrome.com)
2. [1Password](https://agilebits.com/downloads)
3. [Parallels](http://www.parallels.com/products/desktop/download/)
3. App Store: xCode, Slack, Evernote
4. HomeBrew `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
`
5. Key tools: `brew install npm git`
5. zsh: `brew install zsh zsh-completions`
6. [Docker](https://docs.docker.com/docker-for-mac/)
X. [Dropbox](https://www.dropbox.com/downloading?src=index), [Box](https://www.box.com/resources/downloads), Office, [Idea](https://www.jetbrains.com/idea/#chooseYourEdition), [Evernote](https://evernote.com/download/), [Spectacle](https://www.spectacleapp.com/), [Android Studio](https://developer.android.com/studio/index.html)
X. Virtualbox, Vagrant, Vagrant Manager: `brew cask install virtualbox && brew cask install vagrant && brew cask install virtualbox`

## Fonts

[Hack](http://sourcefoundry.org/hack/) font for terminals and editors.


## Terminal

1. Every file in `.private` is sourced. Use this folder for project specific environment variables which you don't want to version control.

You can tell if the terminal has been set up, or at least partially set up if the [solarized](http://ethanschoonover.com/solarized) theme is used. Some good [instructions on setting up a Terminal, tmux and vim for solarized](http://www.terminally-incoherent.com/blog/2012/10/17/vim-solarized-and-tmux/) are available.

- TMux
- Vundle


```bash
# Install Vim for Mac.
brew install macvim --override-system-vim
# Install TMux
brew install tmux
# sudo apt-get install tmux

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

# Keyboard Productivity

1. Vimium Chrome Extension
2. Karabiner keyboard modifier, with fn+hjkl mapped to the arrow keys.

## Vim

1. Clone the `.vimrc`
2. Install Golang binaries: `GoInstallBinaries`.

## NodeJS

Managed via [NVM](https://github.com/creationix/nvm).

```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
```

## Atom

- language-javascript-jsx
- linter
- linter-eslint

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
