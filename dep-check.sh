#!/usr/bin/env bash

# dep-check.sh
# Script to find list of arch packages that are dependencies of currently
# installed packages but are not installed
#
# Pipe list of pacakges to this script using stdin
#
# Author: Amro Diab
# Date: 09/10/17

if [[ ! -p /dev/stdin ]]; then
  echo "No stdin detected.  Pipe list of packages to this script"
  exit
fi

while read -r line; do
  for package in $(pactree -u "$line");do
    pacman -Q "$package" >/dev/null
  done
done < "${1:-/dev/stdin}"
