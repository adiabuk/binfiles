#!/usr/bin/env bash

# Emacs Org-file TODO list generator
# Invoke with prioity level as option to show categorized count of TODO/DONE
# items for each upper level item.  Invoke without any options to see count for
# all priority levels (A, B, and C), but not uncategrized items.
#
# Script output is for display with the conky system monitor app and not
# intended to be run natively
#
# Author: Amro Diab
# Date: 10/08/17

source="$HOME/repos/personal/org-mode/todo.org"

IFS=$(echo -en "\n\b")
list=`grep "^* " $source|cut -c8-|awk -F'\t' '{print $1}'`
TODO=0
DONE=0

if [[ $1 == '-A' ]]; then
  TODO_STR="TODO \[#A\]"
  DONE_STR="DONE \[#A\]"
  TITLE="Priority A"
elif [[ $1 == '-B' ]]; then
  TODO_STR="TODO \[#B\]"
  DONE_STR="DONE \[#B\]"
  TITLE="Priority B"
elif [[ $1 == '-C' ]]; then
  TODO_STR="TODO \[#C\]"
  DONE_STR="DONE \[#C\]"
  TITLE="Priority C"
else
  TODO_STR="TODO \[#[A-C\]"
  DONE_STR="DONE \[#[A-C]\]"
  TITLE="All Priorities"
fi
  printf '${font Open Sans:Bold:size=10}${color tan1}'
  printf "$TITLE\n"
  printf '${color slate grey}$stippled_hr\n'
  #printf '${color slate grey}$stippled_hr\n'

for item in $list; do
  printf '$color${font}${font Open Sans:bold:size=8.5}'
  printf $item
  printf '$font\n'

  for status in "$TODO_STR" "$DONE_STR"; do
    RESULT=`sed "/${item}$/,/^* /!d;//d" $source | grep $status | wc -l`
    #${alignr}
    stat=`echo $status|awk {'print $1'}`
    printf "${stat,,}"
    printf '${alignr}'
    printf "$RESULT \t\n"

    if [[ $status == "DONE"* ]]; then
      DONE=$[$DONE+$RESULT]

    else
      TODO=$[$TODO+$RESULT]
    fi

  done
  
  printf '${color slate grey}$stippled_hr\n'
done

unset IFS

printf '$color${font}${font Open Sans:bold:size=8.5}'
printf "Totals"
printf '$font\n'

printf "todo"
printf '${alignr}'
printf "$TODO\t\n"

printf "done"
printf '${alignr}'
printf "$DONE\t\n"
