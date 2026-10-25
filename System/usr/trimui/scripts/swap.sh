#!/bin/sh
# Optional swap file on the SD card (issue #86). The stock kernel has no zram,
# and heavy PSP/N64 titles approach the 1 GB RAM limit.
#
# The card is vfat; mkswap/swapon work on it (tested on hardware: swapon OK,
# ~52 MB/s write, ~83 MB/s read). This is a safety net, not a speed upgrade.
#
# Usage: swap.sh on|off|status
# Never enabled by default. `on` writes the persistence flag; °post_starts.sh
# re-enables it at boot only when the flag exists.

SWAPFILE="/mnt/SDCARD/.swapfile"
FLAG="/mnt/SDCARD/System/updates/.swap_enabled"
SIZE_MB="512"

case "$1" in
	on)
		if swapon -s 2>/dev/null | grep -q "$SWAPFILE"; then
			echo "swap already on"
			exit 0
		fi
		if [ ! -f "$SWAPFILE" ]; then
			dd if=/dev/zero of="$SWAPFILE" bs=1M count="$SIZE_MB" 2>/dev/null || exit 1
		fi
		mkswap "$SWAPFILE" >/dev/null 2>&1 || { rm -f "$SWAPFILE"; exit 1; }
		sync
		swapon "$SWAPFILE" || { rm -f "$SWAPFILE"; exit 1; }
		echo 10 > /proc/sys/vm/swappiness 2>/dev/null
		touch "$FLAG"
		echo "swap on ($SIZE_MB MB, swappiness 10)"
		;;
	off)
		swapoff "$SWAPFILE" 2>/dev/null
		rm -f "$SWAPFILE"
		rm -f "$FLAG"
		echo "swap off"
		;;
	status)
		if swapon -s 2>/dev/null | grep -q "$SWAPFILE"; then
			swapon -s | grep "$SWAPFILE"
			echo "swappiness: $(cat /proc/sys/vm/swappiness 2>/dev/null)"
		elif [ -f "$FLAG" ]; then
			echo "FLAG set but swap inactive (reboot pending?)"
		else
			echo "OFF"
		fi
		;;
	*)
		echo "usage: swap.sh on|off|status"
		exit 1
		;;
esac
