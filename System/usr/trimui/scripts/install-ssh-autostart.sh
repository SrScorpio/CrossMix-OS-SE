#!/bin/sh
# Remove the SSH autostart experiments. The menu toggle is the switch.
#
# Older hotfixes installed a hook in /etc/rc.local and a copy of the helper in
# /etc, and a procd service (sshse) that this firmware does not start. None of
# that should come back: rc.local is not executed here, and the helper used to
# pkill the menu's dropbear -R.
# Idempotent. Safe to run from a hotfix.

RC="/etc/rc.local"
if [ -f "$RC" ] && grep -q "ssh_start" "$RC" 2>/dev/null; then
	cp -f "$RC" "$RC.bak-se" 2>/dev/null
	grep -v "ssh_start" "$RC" | grep -v "CrossMix-OS SE: reached from" \
		| grep -v "Beacon first: proves init" > /tmp/rc.local.clean
	sh -n /tmp/rc.local.clean 2>/dev/null && cat /tmp/rc.local.clean > "$RC"
	rm -f /tmp/rc.local.clean
fi

rm -f /etc/ssh_start.sh \
	/etc/init.d/sshse \
	/etc/rc.d/S99sshse \
	/etc/rc.d/K10sshse
exit 0
