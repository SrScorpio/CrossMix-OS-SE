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

# MainUI applies its own profile (1.2 GHz floor) when it starts, and it starts
# after rc.local, so writing before it is pointless - measured: the floor came
# back to 1.2 GHz on every boot. Wait for the frontend to be up, give it a moment
# to settle, and only then write. Written once, not in a loop, so a profile the
# user picks afterwards is never fought over.
if [ "$1" = "--after-mainui" ]; then
	i=0
	while [ $i -lt 240 ]; do
		if pidof MainUI >/dev/null 2>&1; then
			sleep 3
			break
		fi
		sleep 0.5
		i=$((i + 1))
	done
fi

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
