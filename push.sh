#!/bin/bash
#
# Push blog articles to Github Pages
# Use `git push -u ...` to set the default branch

git add .

if [[ ! $# -eq 0 ]]
then        
    git commit -m "$*"
else
    git commit -m "new post"
fi

git push -f -u
