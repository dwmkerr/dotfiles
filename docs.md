# docs

Some scattered documentation, needs sorting.

## Clean Mac

3. [Parallels](http://www.parallels.com/products/desktop/download/)
3. App Store: xCode, Slack, Evernote
6. [Docker](https://docs.docker.com/docker-for-mac/)
X. [Dropbox](https://www.dropbox.com/downloading?src=index), [Box](https://www.box.com/resources/downloads), Office, [Idea](https://www.jetbrains.com/idea/#chooseYourEdition), [Evernote](https://evernote.com/download/), [Spectacle](https://www.spectacleapp.com/), [Android Studio](https://developer.android.com/studio/index.html)

## Keyboard Productivity

1. Vimium Chrome Extension
2. Karabiner keyboard modifier, with fn+hjkl mapped to the arrow keys.

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

- https://github.com/mhartington/oceanic-next-iterm

## Project Setup

### NodeJS

- Superagent: for HTTP requests
- Supertest: for testing HTTP requests
- Supertest As Promised: adds promises to Supertest
