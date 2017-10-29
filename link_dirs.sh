#!/usr/bin/env bash

# Create Symlinks for ~/Desktop, ~/Documents, ~/Pictures, ~/tmp
# to googledrrive synced directory
#
# Author: Amro Diab
# Date: 28/07/17

GOOGLE_DRIVE_BACKUP_DIR=~/Drive/my_laptop

cd ~/
for directory in Desktop Documents Pictures tmp; do
  if [[ -d ~/Drive/my_laptop/${directory} ]]; then
    mv $directory ${directory}.old
    ln -sf $GOOGLE_DRIVE_BACKUP_DIR/${directory} ./${directory}
  fi
done
