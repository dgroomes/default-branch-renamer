#!/usr/bin/env bash
#
# Rename the "default" branch of the GitHub git repo in the current working directory from "master" to "main"
#
# Tested using macOS Catalina.

CURRENT_BRANCH=$(git branch --show-current)

if [[ $CURRENT_BRANCH != "master" ]]; then
  echo >&2 "Expected the current branch to be 'master' but was '$CURRENT_BRANCH'"
  exit 1
fi

# Assert there are no changes (i.e. that the directory is "clean")
# Uses a technique from https://stackoverflow.com/a/62768943
if [[ $(git status --porcelain=v1 2>/dev/null | wc -l) -gt 0 ]]; then
  echo >&2 "Expected there to be no changes (i.e. expected the directory to be 'clean') but there are changes"
  exit 1
fi

git pull

git checkout -b main

git push origin main

# TODO use the GitHub API to change the default branch 
