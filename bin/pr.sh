#!/bin/bash
set -e

# Ensure inside git repo
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "Not inside a Git repository"
  exit 1
}

CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
DEFAULT_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')

git push -u origin "$CURRENT_BRANCH"

# Create PR (compatible with both new and old gh versions)
PR_OUTPUT=$(gh pr create --base "$DEFAULT_BRANCH" --head "$CURRENT_BRANCH" --title "Auto PR from $CURRENT_BRANCH" --body "Automated PR from $CURRENT_BRANCH" 2>&1)

# Extract PR URL
PR_URL=$(echo "$PR_OUTPUT" | grep -Eo 'https://github\.com/[^ ]+/pull/[0-9]+' || true)

if [ -z "$PR_URL" ]; then
  echo "Failed to create PR. Output:"
  echo "$PR_OUTPUT"
  exit 1
fi

echo "PR created: $PR_URL"

# Attempt merge but keep the branch
if gh pr merge "$PR_URL" --merge; then
  echo "Branch '$CURRENT_BRANCH' successfully merged into '$DEFAULT_BRANCH' (branch retained)."
else
  echo "Merge conflict detected. Opening PR in browser for manual resolution..."
  open "$PR_URL" 2>/dev/null || xdg-open "$PR_URL" 2>/dev/null || echo "Open manually: $PR_URL"
fi
