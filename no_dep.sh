#!/usr/bin/bash

in_file=$1
out_file=$2
for package in `cat $in_file`; do

  pacman -Qi $package |grep -q "Required By     : None" && echo "no dep in $package" >> $out_file

done

