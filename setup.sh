#!/bin/bash

# Pull the latest hexo branch
git checkout hexo

# Commit and push changes to main branch
git add .
git commit -m "Deploy new content"
git push origin main

# Generate static files
hexo clean && hexo generate && hexo deploy

