#!/bin/bash

git rev-parse --is-inside-work-tree > /dev/null 2>&1 || {
  echo "Not inside a Git repository"
  exit 1
}

CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
DEFAULT_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')

git push -u origin "$CURRENT_BRANCH"
gh pr create --base "$DEFAULT_BRANCH" --head "$CURRENT_BRANCH" --web
