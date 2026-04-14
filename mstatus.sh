#!/bin/sh
kern=$(uname -r)
prev_idle=0 prev_total=0
while :; do
    read _ u n s idle rest < /proc/stat
    total=$((u + n + s + idle))
    cpu=$(( (total - prev_total - (idle - prev_idle)) * 100 / (total - prev_total + 1) ))
    prev_idle=$idle prev_total=$total
    temp=$(awk '{printf "%d", $1/1000}' /sys/class/thermal/thermal_zone0/temp)
    ram=$(free | awk '/Mem:/{printf "%d", $3/$2*100}')
    printf "%s | %s°C | RAM: %s%% | CPU: %s%% | %s \n" \
        "$kern" "$temp" "$ram" "$cpu" "$(date '+%I:%M %p')"
    sleep 5
done
