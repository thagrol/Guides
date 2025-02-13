#!/bin/bash

# simple(ish) script to idenfity which GUI desktop is in use.
# currently assumes that only a single desktop will be active
# and that said desktop is on the real console
#
# Based on a script by dom found at 
#   https://forums.raspberrypi.com/viewtopic.php?t=383250#p2290558

if pgrep labwc > /dev/null; then
  echo "Running Wayland and labwc"
elif pgrep wayfire > /dev/null; then
  echo "Running Wayland and wayfire"
elif pgrep Xorg > /dev/null; then
  if pgrep -f "lxsession -s LXDE-pi" > /dev/null; then
    echo "Running X11 and lxde with RPiOS UI mods."
  elif pgrep -f lxsession > /dev/null; then
    echo "Running X11 and lxde"
  else
    echo "Running X11 with non-default session/window manager"
  fi
else
  echo "Unable to determine. Is the desktop running?"
fi
