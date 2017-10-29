#!/usr/bin/env bash

# Reads text from stdin, and returns number of matches of first argument

number_of_words=0

[ -z $1 ] && echo "supply string to count as argument" && exit 1

while read line; do
  lowerline=$(echo $line | tr A-Z a-z|tr -d "w")
  for word in $lowerline; do

    if [[ $word = "$1" ]] ; then
      let number_of_words++
      echo $word
    fi

  done

done

echo Number of words: $number_of_words
