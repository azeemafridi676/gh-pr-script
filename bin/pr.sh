#!/bin/bash

set -e

# Ensure inside git repo
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "Not inside a Git repository"
  exit 1
}

CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
DEFAULT_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')

# Push branch
git push -u origin "$CURRENT_BRANCH"

# Create PR (without browser open)
PR_URL=$(gh pr create --base "$DEFAULT_BRANCH" --head "$CURRENT_BRANCH" --title "Auto PR from $CURRENT_BRANCH" --body "Automated PR from $CURRENT_BRANCH" --json url -q ".url")

echo "PR created: $PR_URL"

# Try merging
if gh pr merge "$PR_URL" --merge --delete-branch; then
  echo "✅ Branch '$CURRENT_BRANCH' successfully merged into '$DEFAULT_BRANCH'."
else
  echo "⚠️ Merge conflict detected. Opening PR in browser for manual resolution..."
  open "$PR_URL" || xdg-open "$PR_URL"
fi
