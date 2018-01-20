#!/usr/bin/env bash

# Hacky script for resizing jpgs

for i in ls *.jpg;
do
new_name=`echo $i |awk -F. {'print $1'}`_new.jpg


echo $i $new_name
convert $i -resize 800 -quality 50 $new_name
done

