#!/bin/bash
#
# Make a new post in Jekyll
# No guarantee, fuck Bash, fuck Linux!

if [[ ! $# -eq 0 ]]
then
    title="$*"
    # replace spaces
    title=${title// /-}
    title=`date "+%Y-%m-%d-"`$title".md"
    # create post file
    echo $'---\nlayout: post\ntitle: \ncategories: \ntags: \n---' > _posts/$title
    echo "Success."
    vim _posts/$title
else
    echo "Title should not be empty."
fi
