#!/bin/sh
# Build _assets/migration/CE-Migration-1.4.0-ce.2.zip from the working tree.
#
# Run from the repo root (or any cwd; paths are resolved from this script).
# The kit lets an existing upstream CrossMix install (1.2.1 / 1.3.0 / 1.3.9 /
# 1.3.9.1) switch to the SE channel without reflashing: it stamps the version
# key, installs the current updater chain, the CA bundle for authenticated
# downloads, and the SE OTA-update app. It adds/overwrites only the files it
# contains; nothing else on the SD is touched.
#
# Contents (paths relative to SD root /mnt/SDCARD, plus MIGRAR-LEEME.txt):
#   Apps/OTA-update/{launch.sh,config.json,keys.gptk,icon.png}
#   Apps/SystemTools/Menu/NETWORK##Tailscale (state)/Tailscale  - enable.sh
#   System/etc/ssl/ca-certificates.crt
#   System/usr/trimui/crossmix-version.txt
#   System/usr/trimui/scripts/{ota_update,update_common,update_notification,
#                              update_ota_release,crossmix_update,
#                              common_functions,portmaster_fix}.sh
#   MIGRAR-LEEME.txt  (from _assets/migration/)
#
# After any change to these files in main, regenerate the kit and refresh the
# release asset (same name). Do not hand-edit the zip.
#
# Usage: sh _assets/scripts/build-migration-kit.sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
OUT="$ROOT/_assets/migration/CE-Migration-1.4.0-ce.2.zip"
STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT INT TERM

# shellcheck disable=SC2086
FILES="
Apps/OTA-update/launch.sh
Apps/OTA-update/config.json
Apps/OTA-update/keys.gptk
Apps/OTA-update/icon.png
Apps/SystemTools/Menu/NETWORK##Tailscale (state)/Tailscale  - enable.sh
System/etc/ssl/ca-certificates.crt
System/usr/trimui/crossmix-version.txt
System/usr/trimui/scripts/ota_update.sh
System/usr/trimui/scripts/update_common.sh
System/usr/trimui/scripts/update_notification.sh
System/usr/trimui/scripts/update_ota_release.sh
System/usr/trimui/scripts/crossmix_update.sh
System/usr/trimui/scripts/common_functions.sh
System/usr/trimui/scripts/portmaster_fix.sh
"

missing=0
# IFS newline for paths with spaces
OLDIFS=$IFS
IFS='
'
for rel in $FILES; do
	[ -z "$rel" ] && continue
	src="$ROOT/$rel"
	if [ ! -f "$src" ]; then
		echo "missing: $rel" >&2
		missing=1
		continue
	fi
	dir=$(dirname "$rel")
	mkdir -p "$STAGE/$dir"
	cp -a "$src" "$STAGE/$rel"
done
IFS=$OLDIFS

# Migration leaflet, from its source of truth in the repo.
cp -a "$ROOT/_assets/migration/MIGRAR-LEEME.txt" "$STAGE/MIGRAR-LEEME.txt"

if [ "$missing" -ne 0 ]; then
	echo "abort: required tree files missing (sparse checkout?)" >&2
	exit 1
fi

mkdir -p "$(dirname "$OUT")"
rm -f "$OUT"
# Prefer 7z (matches console tooling), fall back to zip.
if command -v 7z >/dev/null 2>&1; then
	(cd "$STAGE" && 7z a -tzip -mx=9 "$OUT" . >/dev/null)
elif command -v 7zz >/dev/null 2>&1; then
	(cd "$STAGE" && 7zz a -tzip -mx=9 "$OUT" . >/dev/null)
elif command -v zip >/dev/null 2>&1; then
	(cd "$STAGE" && zip -r -q "$OUT" .)
else
	echo "abort: need 7z, 7zz or zip" >&2
	exit 1
fi

echo "built: $OUT"
sha256sum "$OUT"
unzip -l "$OUT" 2>/dev/null || 7z l "$OUT" 2>/dev/null || true
