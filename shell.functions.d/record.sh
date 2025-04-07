#!/usr/bin/env bash

cast_to_svg_gif() {
  # Setup:
  # brew install agg

  # Show the help.
  if [ $# -ne 1 ]; then
    echo "Usage: $0 <path>"
    echo "  path : path to the *.cast file"
    echo "Converts <name>.cast to <name>.svg and <name>.gif"
    return 1
  fi

  # Grab the parameters.
  local path="${1%.*}" # path without .extension

  # Convert the cast to SVG.
  svg-term --in "${path}.cast" --out "${path}.svg" --window --no-cursor --from=100

  # Create a gif, useful for sharing online.
  agg --theme monokai "${path}.cast" "${path}.gif"
  agg "${path}.cast" "${path}-default.gif"
  agg --theme github-dark "${path}.cast" "${path}-github-dark.gif"
}

record() {
  # Show the help.
  if [ $# -le 2 ]; then
    echo "Usage: record <directory> <output> <ps1?> <profile?> <title?>"
    echo "  directory: the directory to move to and start the recording in"
    echo "  output   : the output filename, e.g: 'demo' (will be saved in <directory>) "
    echo "  ps1      : (optional) the ps1 name to use (default 'dwmkerr')"
    echo "  title    : (optional) the title of the window"
    echo "  profile  : (optional) the iTerm profile to use"
    return 1
  fi

  # Grab the parameters.
  local dir="$1"
  local outfile="$2"
  local ps1="${3:-dwmkerr}"
  local title="${4:-Terminal AI}"
  local profile="${5:-dwmkerr-recording}"

  # Add your recording logic here, using $dir and $outfile
  echo "Recording from directory '$dir' to file '$outfile' with profile '${profile}'..."

  # - Install [asciinema](https://asciinema.org/) `brew install asciinema`
  # - Check that you have your profiles setup as documented in `./scripts/record-demo.sh`
  # - Run the script to start a 'clean' terminal `./scripts/record-demo.sh`
  # - Download your recording, e.g. to `./docs/620124.cast`
  # - Install [svg-term-cli](https://github.com/marionebl/svg-term-cli) `npm install -g svg-term-cli`
  # - Convert to SVG: `./scripts/demo-to-svg.sh`
  #
  # For this script to work:
  # 1. make sure you have an iterm profile named 'dwmkerr-recording'
  # 2. This profile is in my dotfiles
  # 3. The profile should be windowed, and sized to 80x15.
  osascript <<EOF
tell application "iTerm"
    set newWindow to (create window with profile "${profile}")
    tell current session of newWindow
        write text "clear"
        write text "cd ${dir}"
        write text "set_ps1 ${ps1}"
        write text "asciinema rec --overwrite --title '${title}' ${dir}/${outfile}.cast && echo 'done'"
        write text "echo 'complete'"
    end tell
end tell
EOF
}
