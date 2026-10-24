#!/bin/sh
# Install the idle-floor scene script over the copy MainUI actually execs.
#
# Measured: /usr/trimui/scene/com.trimui.cpuperformance.sh 0 is running at idle,
# started by the firmware, cwd /usr/trimui/scene. The fn_editor copy is not the
# one that runs. The loop used to stop correcting after 120 s of uptime, and
# MainUI stamps min=1200000 after that window, which is why every one-shot hook
# lost. This replaces the scene script with one that corrects only that stamp,
# on every pass, for as long as the menu is up.
#
# Idempotent. Overlay is writable and survives reboot; a firmware update that
# restores the stock script is repaired the next time post_starts runs.

PATH="/mnt/SDCARD/System/bin:/usr/sbin:/usr/bin:/sbin:/bin"
SRC="/mnt/SDCARD/System/usr/trimui/scripts/cpuperformance-se.sh"
DST="/usr/trimui/scene/com.trimui.cpuperformance.sh"
MARK="SE-floor-1200000"

[ -f "$SRC" ] || exit 0
[ -d /usr/trimui/scene ] || exit 0

if [ -f "$DST" ] && grep -q "$MARK" "$DST" 2>/dev/null; then
	exit 0
fi

[ -f "$DST" ] && [ ! -f "$DST.bak-se" ] && cp -f "$DST" "$DST.bak-se" 2>/dev/null
cp -f "$SRC" "$DST" 2>/dev/null || exit 1
chmod 755 "$DST" 2>/dev/null

# If the stock loop is already running, it will not re-read the file. Restart
# only a process whose cwd is the scene dir, so this installer never matches
# itself.
for d in /proc/[0-9]*; do
	[ "$(readlink "$d/cwd" 2>/dev/null)" = "/usr/trimui/scene" ] || continue
	pid=${d#/proc/}
	kill "$pid" 2>/dev/null
done
/usr/bin/setsid /bin/sh "$DST" 0 >/dev/null 2>&1 &
exit 0
