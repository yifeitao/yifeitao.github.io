#!/bin/bash

cp .git/config config && rm -rf .git && git init && git checkout -b gh-pages && mv config .git/config && ./push.sh Initial commit