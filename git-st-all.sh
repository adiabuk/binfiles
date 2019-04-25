#!/bin/bash

# Git status of all repositories found in current directory

for dir in *; do
  if [[ -d "$dir" ]]; then
    printf "\033[0m"  # White
    echo " * $dir"
    printf "\033[31m"  #red
    cd "$dir" || exit 1;
    git st . 2>&1 |grep -vE "On branch|origin|nothing|^$";
    cd - &> /dev/null || exit 1;
  fi
done

printf "\033[0m"  # White
