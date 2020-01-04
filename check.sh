#!/bin/sh

restic_prefix=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

"$restic_prefix"/wrapper.sh check
