#!/bin/bash

# Check if pdf file has OCR/text content
# If not, convert using pypdfocr, otherwise rename
#
# Author: Amro Diab
# 2017
PDFCHECK=/home/amro/repos/personal/pdfgrep/pdfgrep/pdfcheck.py

for file in $(find . -iname "*.pdf"|grep -v ocr); do
  if $PDFCHECK "$file" | grep -q FAILED; then
    echo "ocring file $file"
    pypdfocr "$file"

  else
    renamed=${file/_ocr/}
    echo "renaming file to $renamed"
    #mv "$file" "$renamed"
  fi
done

