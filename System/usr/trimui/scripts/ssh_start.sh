#!/bin/sh
# SSH is started from the menu, on purpose. Do not start it here.
#
# This file used to launch dropbear at boot and, if the running server was the
# menu one (dropbear -R, no -s), it ran pkill dropbear. That is the opposite of
# what was asked: the menu toggle is the switch, and killing it drops the session.
# Callers in post_starts, ex_init and customization may still invoke this path.
# Exiting here makes those calls harmless.
exit 0
