#!/bin/bash

git submodule foreach '
    git fetch
    git checkout origin/master
'

# Check if there are changes
if [[ -n $(git status -s) ]]; then
    # Commit and push changes
    git add .
    git commit -m "🪴 Daily update of submodules $(date +%Y-%m-%d)"
    git push origin master
fi