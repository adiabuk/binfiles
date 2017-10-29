#!/bin/bash

################################################


# This script checks for config in /etc/vz/conf
# which is not associated with any running instance


###############################################
config_dir=/etc/vz/conf

cd "$config_dir" || exit 1
for i in $(ls *.conf|grep -v ^0|awk -F. {'print $1'}); do

  printf "Checking $i..."
  vzlist $i 2>&1 | grep -q $i && echo OK || echo "FAILED: $i does not exist"

done

echo "Done checking config";echo
