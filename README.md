# pr-script

This script automates the entire GitHub Pull Request workflow with a single `pr` command. It pushes your current branch, creates a PR, attempts to auto-merge if there are no conflicts, and switches you to the main branch - saving you from tedious manual steps and browser navigation. Perfect for developers who want to streamline their git workflow and reduce context switching.

## Setup

### Prerequisites

```bash
# Install GitHub CLI (works on macOS, Linux, Windows)
brew install gh          # macOS with Homebrew
# OR follow: https://cli.github.com/

# Authenticate
gh auth login
```

### Install Script

```bash
# Clone repository
git clone https://github.com/azeemafridi676/script-to-automate-GitHub-PR-using-a-single-pr-command..git pr-script

# Make executable
chmod +x pr-script/bin/pr.sh

# Add global alias (replace /path/to/ with your actual path)
echo 'alias pr="/path/to/pr-script/bin/pr.sh"' >> ~/.zshrc    # macOS/zsh
echo 'alias pr="/path/to/pr-script/bin/pr.sh"' >> ~/.bashrc   # Linux/bash
echo 'alias pr="/path/to/pr-script/bin/pr.sh"' >> ~/.bash_profile   # macOS/bash

# Reload shell
source ~/.zshrc    # or ~/.bashrc
```

## Usage

When you want to create a PR and merge your current branch with the default main branch (master/main/etc), simply run:

```bash
pr
```

- **No conflicts**: Branch gets merged automatically in your GitHub repo and you're switched to the main branch
- **Conflicts exist**: PR gets created and opened in your browser for manual resolution

That's it. Super easy to use.
