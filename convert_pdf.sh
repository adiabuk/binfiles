#!/bin/bash

# Check if pdf file has OCR/text content
# If not, convert using pypdfocr, otherwise rename
#
# Author: Amro Diab
# 2017

for file in $(find . -iname "*.pdf"|grep -v ocr); do
  if pdfcheck "$file" | grep -q FAILED; then
    echo "ocring file $file"
    pypdfocr "$file"

  else
    renamed=${file/_ocr/}
    echo "renaming file to $renamed"
    mv "$file" "$renamed"
  fi
done

