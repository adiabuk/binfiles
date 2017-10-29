#!/bin/bash

#
# deploy.sh - copy files using cp and rsync
#
#
# Copyright (C) 2011 Amro Diab
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#
# Report bugs to: adiab@linuxmail.org
#
# 14.10.2011 v.1.0 - First Draft


UMASK=022
RSYNC=/usr/bin/rsync
CP=/bin/cp


umask $UMASK

function check_proceed {
  read -pr "Are you sure you want to continue? <y/N> " prompt

  if [[ ( ! $prompt == y* ) || ( ! $prompt == Y* )  ]]; then
    echo "Exiting process...";
    exit 0
  fi
}

function rsync_func() {
  echo "Rsyncing $SOURCE to $HOST:$DEST"
  check_proceed
  if not $RSYNC -rlpt --stats  "$SOURCE" "$DEST"; then
    echo "Unable to copy files, giving up..."
    exit -1
  fi
  echo "Complete..."
}

function help_func() {
  echo;
  echo "Usage: $0 -s <source_dir> -d <destination_dir> -t <type> [ -h ]"
  echo "Options:
  -h Print detailed help screen
  -s <source_dir>
  -d <destination_dir>
  -t type <copy|rsync>"
  echo
}

function copy_func() {
  echo "Copying files from $SOURCE to $DEST..."
  check_proceed
  if not $CP -rv "$SOURCE $DEST"; then
    echo "Unable to copy files, giving up..."
    exit -1
  fi
  echo "Complete..."
}


while getopts ":t:hs:d:H:" option
do
  case $option in
    t ) type=$OPTARG ;;
    s ) SOURCE=$OPTARG;;
    d ) DEST=$OPTARG ;;
    h ) help_func;exit 0 ;;
    H ) echo "hostname" ;;
    * ) echo "Invalid Options passed, giving up..."; help_func; exit -1
  esac
done

if [[ -z "$SOURCE" ]] || [[ -z "$DEST" ]]; then
  echo "ERROR: Please specify Source and destination"
  help_func
  exit 3
fi

echo "source,dest: $SOURCE,$DEST"
echo "You chose type $type"

if [[ "$type" == rsync ]]; then
  echo "loading rsync..."
  rsync_func
elif [[ "$type" == copy ]] ; then
  copy_func;
else
  echo "Choose either copy or rsync as transfer type"; help_func
fi


