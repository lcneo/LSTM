#!/bin/bash
git fetch origin
git merge origin/master
git add -A
git commit -m "git for LAB"
git push
