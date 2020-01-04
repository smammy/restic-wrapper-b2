#!/bin/sh

restic_prefix=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

"$restic_prefix"/wrapper.sh backup \
    $(cat "$restic_prefix"/conf/dirs) \
    --one-file-system \
    --exclude-caches \
    --exclude-file="$restic_prefix"/conf/exclude
"$restic_prefix"/wrapper.sh forget \
    --keep-daily=7 \
    --keep-weekly=4 \
    --keep-monthly=12 \
    --keep-yearly=5
"$restic_prefix"/wrapper.sh prune
