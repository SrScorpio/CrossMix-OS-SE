#!/bin/sh
# Install the power profile so it applies on every boot.
#
# Same mechanism as the SSH helper, and for the same reason: /etc/rc.local is the
# one hook this firmware actually runs at boot. The profile is copied into /etc
# (writable overlay) so it does not depend on the card being mounted yet, and it
# only touches sysfs, so it finishes in milliseconds.
#
# Idempotent: safe to run from a hotfix, from the menu, or by hand.

RC="/etc/rc.local"
SRC="/mnt/SDCARD/System/usr/trimui/scripts/cpufreq-profile.sh"
DST="/etc/cpufreq-profile.sh"
HOOK="/bin/sh $DST >/dev/null 2>&1"

[ -f "$SRC" ] || exit 0

cp -f "$SRC" "$DST" 2>/dev/null && chmod +x "$DST" 2>/dev/null

[ -f "$RC" ] || exit 0

grep -q "$HOOK" "$RC" && exit 0

cp -f "$RC" "$RC.bak-se" 2>/dev/null

grep -v "cpufreq-profile.sh" "$RC" > /tmp/rc.local.clean

TMP="/tmp/rc.local.new"
LINE=$(grep -n "^exit 0" /tmp/rc.local.clean 2>/dev/null | head -1 | cut -d: -f1)

if [ -n "$LINE" ]; then
	head -n $((LINE - 1)) /tmp/rc.local.clean > "$TMP"
else
	cat /tmp/rc.local.clean > "$TMP"
fi

cat >> "$TMP" <<EOF

# CrossMix-OS SE: keep the idle clock at its floor, not at 1.2 GHz.
$HOOK
EOF

if [ -n "$LINE" ]; then
	tail -n +"$LINE" /tmp/rc.local.clean >> "$TMP"
fi

sh -n "$TMP" 2>/dev/null || {
	echo "install-cpufreq-profile: refusing to install, result does not parse" >&2
	rm -f "$TMP" /tmp/rc.local.clean
	exit 1
}

cat "$TMP" > "$RC"
rm -f "$TMP" /tmp/rc.local.clean
exit 0
