# terminal

For terminal colours, I like [atom-one-dark-terminal](https://github.com/nathanbuchar/atom-one-dark-terminal).

The repo has been cloned here for quick access, but should be updated from time to time.

## OBS Terminal Recording Setup

1. **OBS**: Create scene → Add "Window Capture" source → Select Terminal window
2. **Global Hotkeys**: OBS Preferences → Hotkeys → Enable "Global Hotkeys" (requires Accessibility permissions)
3. **iTerm**: Disable `Cmd+Shift+P` conflict: Preferences → Keys → Key Bindings → Add `Cmd+Shift+P` as "Ignore"
4. **Recording**: `Cmd+Shift+R` (start/stop), `Cmd+Shift+P` (pause) - works from any app
5. **Files**: Right-click OBS → "Show Recordings" to find .mp4 files for SharePoint upload

## Recording and Displaying Keystrokes

[KeyCastr](https://github.com/keycastr/keycastr) shows your keystrokes on screen during recordings.

1. **Install**: `brew install --cask keycastr`
2. **Toggle on/off**: ⇧⌃⌥K
