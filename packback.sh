#!/usr/bin/env bash

# Backup and restore Arch Linux installed packages
#
# Warning: installs AUR packages without prompting
#          so ensure packages have been checked before hand
#          eg. on a different host
#
# Author:  Amro Diab
# Date:    25/07/2017

function usage () {
  cat << EOF
Usage: $0 [-g|-p] -f <filename>

Get and put arch packages on the system using pacman and yaourt

  -g    Get packages
  -p    Put packages
  -f    filename
  -h    Show this message

EOF

  exit 1
}

while getopts "hgpf:" opt; do
  case $opt in
    g)
      GET=true
      ;;
    h)
      usage
      ;;
    p)
      PUT=true
      ;;
    f)
      FILENAME=$OPTARG
      DIRNAME=$(dirname $FILENAME)
      ;;
    \?)
      printf 'invald option\n\n'
    esac

done

if [[ -z $FILENAME ]]; then
  printf 'Missing filename\n\n'
  usage
elif [[ -n $GET && -n $PUT ]]; then
  printf 'Specify put or get not both\n'
  usage
elif [[ -z $GET && -z $PUT ]]; then
  printf 'Specify either put or get\n\n'
  usage
elif [[ ! -d $DIRNAME ]]; then
  printf 'Invalid path\n\n'
  usage
elif [[ -n $PUT && ! -f $FILENAME ]]; then
  printf 'Invalid file\n\n'
  usage

elif [[ -n $GET ]]; then
  pacman -Qq > $FILENAME
elif [[ -n $PUT ]]; then
  < $FILENAME xargs -I % yaourt -S --force --needed --noconfirm %
fi
