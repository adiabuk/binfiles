#!/bin/bash

USER=$1
EXTRA=$2
DIR=$3


function dobackup(){

/usr/bin/lftp -c "set ftp:passive-mode off net:limit-rate 5120 -a; open \
  ftp://$USER:167233@192.168.1.80:21; mirror --reverse --depth-first \
  --use-cache --verbose --allow-chown \
  --allow-suid --no-umask --parallel=1 $EXTRA --exclude-glob .svn"
}

if [[  "$DIR" == "backup" ]]; then
  cd /var/backups/amrox || exit
  dobackup
  cd /var/backups/mysqlbackups || exit
  dobackup
else
  dobackup
fi


