aigc() {
  # Generate the commit message using terminal-ai. Pipe it into 'git commit'
  # by using the '-F -' (i.e. read from the stdin file). Make sure we edit it
  # in the editor first with '-e'.
  git diff --cached |\
    ai -- 'summarise this git diff into a conventional commit, e.g. feat(feature): short description\n\nlong description' |\
    git commit -e -F - 
}


