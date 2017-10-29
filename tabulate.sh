#!/bin/bash

# tabulate.sh
# Read from stdin and print with a border

if [[ ! -p /dev/stdin ]]; then
  echo "No stdin detected. Pipe text to this script to tabulate"
  exit 1
fi

{ echo -e "<html>\n<table border=1 cellpadding=0 cellspacing=0>"
  paste "$@" |sed -re 's#(.*)#\x09\1\x09#' -e 's#\x09# </pre></td>\n<td><pre> #g' -e 's#^ </pre></td>#<tr>#' -e 's#\n<td><pre> $#\n</tr>#'
  echo -e "</table>\n</html>"
} |w3m -dump -T 'text/html'
