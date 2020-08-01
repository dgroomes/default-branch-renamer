#!/usr/bin/env bash
#
# Rename the "default" branch of the GitHub git repo in the current working directory from "master" to "main"
#
# Requires a GitHub personal access token. Read about authentication to the GitHub API at https://docs.github.com/en/rest/overview/other-authentication-methods
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

if [[ "x$GITHUB_ACCESS_TOKEN" == "x" ]]; then
  echo >&2 "Expected GITHUB_API_TOKEN to be set but was not"
  exit 1
fi

if [[ "x$GITHUB_USERNAME" == "x" ]]; then
  echo >&2 "Expected GITHUB_USERNAME to be set but was not"
  exit 1
fi

set -eu

# Extract the GitHub org name and repo name from the remote URL (assumes that "origin" is the remote)
# First, detect if the "git@xyz" protocal is used of "https://"
URL=$(git config --get remote.origin.url)
if [[ "$URL" == http* ]]; then
  [[ "$URL" =~ github\.com/(.+)/(.+)(\.git)? ]]
  ORG=${BASH_REMATCH[1]}
  REPO=${BASH_REMATCH[2]}
  echo "Detected ORG=$ORG and REPO=$REPO"
elif [[ $URL == git* ]]; then
  echo "Detected 'git@'-based remote URL"
  echo "Unsupported. Please developer the regex and open a Pull Requests"
  exit 1
else
  echo >&2 "Unrecognized URL $URL"
  exit 1
fi

git pull

# Rename "master" to "main"
git branch -m main

git push origin main

# Use the GitHub API to change the default branch
curl --request PATCH \
  --url https://api.github.com/repos/$ORG/$REPO \
  --user "$GITHUB_USERNAME:$GITHUB_ACCESS_TOKEN"\
  --header 'accept: application/vnd.github.v3+json' \
  --header 'content-type: application/json' \
  --data '{
	"default_branch": "main"
}'

# Delete 'master' from the remote
git push origin :master
