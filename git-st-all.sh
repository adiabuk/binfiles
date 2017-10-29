#!/bin/bash

# Git status of all repositories found in current directory

for i in *; do
  if [[ -d "$i" ]]; then
    printf "\033[31m"  #red
    echo "$i"
    printf "\033[0m"  # White
    cd "$i" || exit 1;
    git st .;
    cd - || exit 1;
  fi
done

