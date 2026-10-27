#!/bin/sh
# Legacy version-key stub (1.3.9.1): delegates to the canonical CE hotfix.
# Migrated consoles may still hold an upstream key in crossmix-version.txt;
# without this file Check Update would report "No hotfix available".
#
# TLS policy (fail-closed): never fall back to -k/--no-check-certificate.
# ota_fetch (from update_common.sh) validates against the SD CA bundle;
# the fallback uses curl --cacert only if the bundle exists.
source /mnt/SDCARD/System/usr/trimui/scripts/update_common.sh
CA=/mnt/SDCARD/System/etc/ssl/ca-certificates.crt
url="https://raw.githubusercontent.com/SrScorpio/CrossMix-OS-SE/main/_assets/hotfixes/CrossMix-OS_v1.4.0-ce.2.sh"
tmp=/tmp/crossmix_ce_hotfix.sh

if command -v ota_fetch >/dev/null 2>&1; then
    ota_fetch -s -L -o "$tmp" "$url" || { echo "TLS download failed (rc=$?)" >&2; exit $?; }
elif [ -f "$CA" ]; then
    curl --cacert "$CA" -s -L -o "$tmp" "$url" || { echo "TLS download failed (rc=$?)" >&2; exit $?; }
else
    echo "No ota_fetch and no CA bundle - refusing insecure download. Install the CE migration kit (fail-closed)" >&2
    exit 60
fi

echo "Legacy key 1.3.9.1 detected -> applying canonical CE hotfix"
sh "$tmp"
rc=$?
rm -f "$tmp"
exit $rc
