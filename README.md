# Restic wrappers for system backup to Backblaze B2

## Manifest

```
README.md    - this file

bin/         - Restic static binary dir (all arches).
cache/       - Local repo cache dir.
conf/b2-id   - Backblaze B2 Application Key ID.
conf/b2-key  - Backblaze B2 Application Key.
conf/dirs    - List of paths to back up.
conf/exclude - List of paths to exclude from backups.
conf/pass    - Restic repository password.
conf/repo    - Restic repository name.
conf/version - Version of restic binary to use.

backup.sh    - Run a backup and prune existing backups.
check.sh     - Verify existing backups.
wrapper.sh   - Convenience wrapper; reads configuration and fetches/runs
               restic binary appropriate for the current arch and OS.
```

## Setup

### Clone this repository

```sh
git clone https://github.com/smammy/restic-wrapper /opt/restic
```

### Add configuration

```sh
cd /opt/restic

echo "b2:your-b2-bucket-name:" > conf/repo
echo "your restic repo password" > conf/pass
echo "your b2 app key id" > conf/b2-id
echo "your b2 app key" > conf/b2-key
echo "/" > conf/dirs
echo <<'EOT' > conf/exclude
/home/*/.cache
/tmp
/var/cache
/var/tmp
EOT
```

### Install crontab

```sh
cp crontab /etc/cron.d/restic
```

## Generating a restore bundle

A restore bundle contains all the files necessary to restore from the configured restic repo.

```sh
( umask 077 && sudo tar -C /opt/ -cvJf- --exclude-caches --exclude bin restic > restic-bundle-for-$HOSTNAME.tar.xz )
```

WARNING: this bundle will contain your B2 credentials and repo password! You should probably encrypt it.
