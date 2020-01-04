#!/bin/sh

/opt/restic/wrapper.sh backup \
    $(cat /opt/restic/conf/dirs) \
    --one-file-system \
    --exclude-caches \
    --exclude-file=/opt/restic/conf/exclude
/opt/restic/wrapper.sh forget \
    --keep-daily=7 \
    --keep-weekly=4 \
    --keep-monthly=12 \
    --keep-yearly=5
/opt/restic/wrapper.sh prune
