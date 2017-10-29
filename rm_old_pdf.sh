#!/bin/bash

# check PDF file for OCR content
# Rename with _ocr suffix, delete old non-ocr version if both exist
#
# Author: Amro Diab
# 2017

for ocr in *ocr*; do
  non_ocr=${ocr/_ocr/}
  ls "$ocr"
  if [[ -f "$non_ocr" ]]; then
    echo "NON OCR exists: $non_ocr"
    if pdfcheck "$ocr" | grep -q OK; then
      echo "OCR OK - deleting"
      rm "$non_ocr"
    fi
  fi
done

