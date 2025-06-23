# pr-script

A shell script to automate GitHub Pull Request creation from the terminal using a single `pr` command.

---

## Features

- Verifies if inside a Git repository  
- Gets current branch and default remote branch  
- Pushes current branch to `origin`  
- Creates a pull request using GitHub CLI (`gh`)  
- Opens the pull request in your default browser  

---

## Requirements

- **git** (pre-installed on macOS)  
- **GitHub CLI (`gh`)**

### Install `gh`

Follow instructions from: https://cli.github.com/  
Or use Homebrew:

```bash
brew install gh
````

Authenticate `gh`:

```bash
gh auth login
```

You must be authenticated for `gh pr create` to work.

---

## Installation

### Step 1: Clone this repository

```bash
https://github.com/azeemafridi676/script-to-automate-GitHub-PR-using-a-single-pr-command..git
```

### Step 2: Make the script executable

```bash
chmod +x pr-script/bin/pr.sh
```

### Step 3: Add an alias to your shell config

#### For zsh (macOS default):

```bash
echo 'alias pr="$HOME/path/to/pr-script/bin/pr.sh"' >> ~/.zshrc
```

#### For bash:

```bash
echo 'alias pr="$HOME/path/to/pr-script/bin/pr.sh"' >> ~/.bashrc
```

Replace `/path/to/` with the absolute path to the cloned repo.

### Step 4: Reload your shell config

#### For zsh:

```bash
source ~/.zshrc
```

#### For bash:

```bash
source ~/.bashrc
```

### Step 5: Confirm alias is active

```bash
which pr
```

Expected output:

```bash
pr is aliased to /Users/yourname/path/to/pr-script/bin/pr.sh
```

---

## Usage

Inside any Git repository, run:

```bash
pr
```

What happens:

* Checks if inside a Git repository
* Determines the current local branch
* Determines the default branch of origin (usually `main` or `master`)
* Pushes the current branch to origin
* Creates a pull request with `gh pr create`
* Opens the pull request in your browser

### Example

```bash
git checkout -b feature-x
# make changes, commit them
pr
```

Creates and opens a PR from `feature-x` to `main`.

---

## Troubleshooting

* **Not inside a Git repository**
  Check your current directory.

* **`gh pr create` fails**
  Ensure you're logged in via `gh auth login`.

* **Default branch detection fails**
  Ensure `origin` exists and has a HEAD reference.

---

## Script Contents (`bin/pr.sh`)

```bash
#!/bin/bash

git rev-parse --is-inside-work-tree > /dev/null 2>&1 || {
  echo "Not inside a Git repository"
  exit 1
}

CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
DEFAULT_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')

git push -u origin "$CURRENT_BRANCH"
gh pr create --base "$DEFAULT_BRANCH" --head "$CURRENT_BRANCH" --web

