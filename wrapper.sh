#!/bin/sh

ext=bz2
inflate=bzcat

case "$(uname -s)" in
	*Darwin*)                          os=darwin  ;;
	*FreeBSD*)                         os=freebsd ;;
	*Linux*)                           os=linux   ;;
	*OpenBSD*)                         os=openbsd ;;
	*Windows*|*CYGWIN*|*MINGW*|*MSYS*) os=windows  ext=zip inflate='unzip -p' ;;
	*) echo "unknown system" >&2; exit 2 ;;
esac

case "$(uname -m)" in
	i*86)         arch=386   ;;
	x86_64|amd64) arch=amd64 ;;
	arm*)         arch=arm   ;;
	aarch64)      arch=arm64 ;;
	*) echo "unknown machine" >&2; exit 3 ;;
esac

restic_prefix=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
restic_version=$(cat "$restic_prefix/conf/version")
restic_bindir="$restic_prefix/bin"
restic_binfile="restic_${restic_version}_${os}_$arch"
restic_bin="$restic_bindir/$restic_binfile"
restic_url="https://github.com/restic/restic/releases/download"

RESTIC_REPOSITORY=$(cat "$restic_prefix/conf/repo")
RESTIC_PASSWORD_FILE="$restic_prefix/conf/pass"
B2_ACCOUNT_ID=$(cat "$restic_prefix/conf/b2-id")
B2_ACCOUNT_KEY=$(cat "$restic_prefix/conf/b2-key")
export RESTIC_REPOSITORY RESTIC_PASSWORD_FILE B2_ACCOUNT_ID B2_ACCOUNT_KEY

[ -e "$restic_bindir" ] || mkdir -p "$restic_bindir"
[ -e "$restic_bin" ] \
    || curl -L -\# "$restic_url/v$restic_version/$restic_binfile.$ext" \
        | $inflate > "$restic_bin"
[ -x "$restic_bin" ] || chmod +x "$restic_bin"

exec "$restic_bin" --cache-dir="$restic_prefix/cache" "$@"
