#!/usr/bin/env bash
v=$(cat /sys/class/power_supply/BAT0/capacity)
echo "${v}%"
