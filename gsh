#!/bin/bash

# Compile and run c/c++ script

filename=$1

prefix=$(echo "$filename" | awk -F. '{print $1}')

g++ "$filename" -o ./"${prefix}".o
./"${prefix}".o
