#!/bin/bash

for i in `find |grep _ocr_ocr`; do
  renamed=`echo $i|sed 's/_ocr_ocr/_ocr/g'`
  echo $i
  echo $renamed
  echo
  mv $i $renamed
done
