#!/bin/bash

# Check if the script is run from a Git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: This script must be run inside a Git repository."
  exit 1
fi

# Update all submodules to their latest commits on the 'master' branch
echo "Updating all submodules to the 'master' branch..."

# Iterate through all submodules
git submodule foreach --quiet '
  echo "Updating submodule: $name"

  # Fetch the latest changes
  git fetch origin master

  # Check out the master branch
  git checkout master || {
    echo "Error: Failed to check out the master branch in $name. Skipping."
    continue
  }

  # Pull the latest changes
  git pull origin master || {
    echo "Error: Failed to pull the latest changes in $name. Skipping."
    continue
  }

  echo "$name successfully updated to the latest master."
'

echo "Submodule updates complete."

# Stage the updated submodule commits in the main repository
echo "Staging updated submodule references in the main repository..."
git add .gitmodules
git add $(git submodule foreach --quiet --recursive 'echo $path')

echo "Done. Commit the changes with 'git commit' if necessary."
