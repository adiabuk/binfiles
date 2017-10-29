#!/usr/bin/env sh

# Script to display screen resolutions in a dropdown
# selected resolution is for DP-2 Thunderbold.
# I used this to display resolution on an external monitor
# when running Ubuntu 14.04 on a Macbook Pro

choice=$(zenity --list \
  --title="Choose Resolution" \
  --radiolist \
  --text="Choose your resolution" \
  --column="" --column="resolution"  \
    a 2880x1800  \
    b 2560x1600  \
    c 1920x1200 \
    d 1680x1050 \
    e 1400x900 \
    f 1400x1050 \
    g 1280x800 \
    h 640x400 \
    i 320x200 ) || exit 1

w=$(echo $choice|awk -Fx {'print $1'})
check=$(xrandr -q | grep DP-2 | cut -d " " -f 3 | cut -d "x" -f 1)

if [ "$w" -eq "$check" ]; then
  echo "The screen is already at this resolution"
  exit 1;

else

  xrandr --output DP-2 --scale 1x1;
  sleep 3;

  scale_w=$(echo "scale=4; $w/2880" | bc; exit );
  arg=$(echo "$scale_w""x""$scale_w")
  xrandr --output DP-2 --scale $arg
fi
