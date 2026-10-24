#!/bin/sh
echo "============= scene CPU Performance ============"

# SE-floor-1200000
# Replaces /usr/trimui/scene/com.trimui.cpuperformance.sh.
# Mode 1 is the stock game path. Mode 0 only rewrites MainUI's idle stamp
# (min 1200000 / max 2000000). Anything else — a game, the OSD, powersave —
# is left alone, so this loop can run for the whole session without fighting
# a choice the user actually made.
# read is a builtin: this process is started by MainUI with a PATH that has
# neither cut nor, reliably, cat.

while true; do
    case "$1" in
    1)
        if [ -f "/tmp/cmd_to_run.sh" ]; then
            echo performance >/sys/devices/system/cpu/cpufreq/policy0/scaling_governor
            echo -n "2000000" >/sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq
            echo -n "2000000" >/sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq
        fi
        ;;
    0)
        for p in /sys/devices/system/cpu/cpufreq/policy*; do
            [ -f "$p/scaling_min_freq" ] || continue
            read -r MIN < "$p/scaling_min_freq" 2>/dev/null
            read -r MAX < "$p/scaling_max_freq" 2>/dev/null
            if [ "$MIN" = "1200000" ] && [ "$MAX" = "2000000" ]; then
                echo ondemand > "$p/scaling_governor" 2>/dev/null
                echo -n "408000" > "$p/scaling_min_freq" 2>/dev/null
                read -r U _ < /proc/uptime 2>/dev/null
                echo "floor uptime=${U%%.*}" >> /mnt/SDCARD/System/updates/cpufreq-floor.log 2>/dev/null
            fi
        done
        ;;
    *) ;;
    esac
    sleep 5
done
