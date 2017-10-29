#!/bin/bash

# cleanup_coredump.sh
# delete old coredumps based on age and number of dumps found of a particular
# filename prefix
#
# Author: Amro Diab
# Date: 09/03/2013

core_path='/var/tmp/cores/'
days_to_keep=7
files_per_prefix=5
filename=$(basename "$0"|awk -F. '{print $1}')

function usage(){

  cat 1>&2  << EOF
$filename [options]
  --quiet          run with no output
  --log            log output to /tmp/${filename}.log
  --test           show output but don't delete anything
  --help           show this message

EOF
exit 1
}


case $1 in
  --quiet)
  quiet='yes'
  shift
  ;;
  --help)
  shift
  ;;
  --test)
  shift
  ;;
  --log)
  shift
  ;;
  "")
  echo "none"
  ;;
  *)
  usage
esac

function output(){

  if [[ $quiet != "yes" ]]; then
    echo "$@"
  fi

}

# list of files older than x days
age=$(ionice -c 3 find $core_path -type f -mtime +$days_to_keep -print)

FILES_TO_DELETE+=$age

# find different filename prefixes - return amount of files for each prefix
ionice -c3 find /var/tmp/cores | awk -F/ '{print $NF}' \
    | awk -F. '{print $1}' | sed -e "s/[0-9]*$//" \
    | sort | uniq -c | { while read -r cores_sorted; do

  quantity=$(echo "$cores_sorted" | awk '{print $1}');
  prefix=$(echo "$cores_sorted" | awk '{print $2}');

  if [[ $quantity -gt $files_per_prefix ]]; then
    output "found files to delete"
    new_files=$(find "${core_path}" -name "${prefix}*" -maxdepth 1 \
      -printf "%T+\t%p\n" | sort|head -n5|awk -F/ '{print $NF}')

    FILES_TO_DELETE+="$new_files"
  fi
  output "to delete: $(echo "$new_files"| wc -w)"

  output "====================="

done

output "Total count: $(find "$core_path" -maxdepth 1 -type f|wc -l)"
output "to delete: $(echo "$FILES_TO_DELETE" | wc -w)"

ionice -c3 rm -fv "$FILES_TO_DELETE"

}
