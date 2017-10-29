#!/bin/bash

# Find & convert jpegs to pdf

for jpeg in $(find -iname "*.jpg"); do
  echo $jpeg
  new_name=$(echo $jpeg|sed 's/.jpg/.pdf/Ig')
  echo $new_name
  echo
  convert $jpeg $new_name
done
