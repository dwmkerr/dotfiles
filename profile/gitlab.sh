#!/usr/bin/env bash

# git push that directly opens merge request in GitLab
gpmr() {
  # push to current branch to remote origin
  gitOutput=`git push origin $(git_current_branch) 2>&1` && \
  # get URL for merge request
  mrURL=`echo $gitOutput | awk '/remote:   http/ {print $2}'` && \
  # open new merge request
  open -a Google\ Chrome $mrURL
}
