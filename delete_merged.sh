#!/usr/bin/env bash

# Cleanout local & remote git branches
# by deleting/pruning those already merged
#
# Author: Amro Diab 02/09/17

git checkout master
git fetch
git branch|grep -v master | xargs git branch -d
git remote prune origin
