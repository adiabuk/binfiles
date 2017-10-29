#!/usr/bin/env bash

# Small script to get battery information from conky
# Supply grep paremeter as first argument

row=$1
set -eu
set -o pipefail

function usage
{
  echo "Usage: $0 [state|percent|time]"
  exit 1
}

[[ -z $row ]] && usage

upower -i /org/freedesktop/UPower/devices/battery_BAT0|grep $row |awk -F'  ' \
  {'print $NF'}|sed 's/^ //' || echo N/A

exit 0
