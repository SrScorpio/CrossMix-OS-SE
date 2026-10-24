#!/bin/sh
# CrossMix SE power profile.
#
# The stock setup left all four cores at a 1.2 GHz floor, so they never dropped
# below that even with nothing running: the console ran warm and burned battery
# while idle. ondemand raises the clock on its own the moment something needs it,
# so lowering the floor costs nothing in games and saves heat and power the rest
# of the time.
#
# The ceiling stays at 2 GHz: this only changes what happens when the console is
# idle, never what it can do under load.

export PATH="/mnt/SDCARD/System/bin:/usr/sbin:/usr/bin:/sbin:/bin"

GOV="ondemand"
MIN_FREQ=408000
MAX_FREQ=2000000

for p in /sys/devices/system/cpu/cpufreq/policy*; do
	[ -d "$p" ] || continue

	# Never write a governor the kernel does not offer: that leaves the CPU on
	# whatever it had, silently.
	if [ -f "$p/scaling_available_governors" ]; then
		case " $(cat "$p/scaling_available_governors" 2>/dev/null) " in
			*" $GOV "*) : ;;
			*) GOV=$(awk '{print $1}' "$p/scaling_available_governors" 2>/dev/null) ;;
		esac
	fi

	# Ceiling first, floor second: the other way round can be rejected when the
	# new floor is above the old ceiling.
	echo "$MAX_FREQ" > "$p/scaling_max_freq" 2>/dev/null
	echo "$MIN_FREQ" > "$p/scaling_min_freq" 2>/dev/null
	echo "$GOV" > "$p/scaling_governor" 2>/dev/null
done

exit 0
