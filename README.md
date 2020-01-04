# Restic wrappers for system backup to Backblaze B2

## Manifest

```
README.md    - this file

bin/         - Restic binary dir.
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

crontab      - Example crontab to run backup.sh and check.sh.
```

## Setup

### Clone this repo

```sh
git clone https://github.com/smammy/restic-wrapper /opt/restic
```

### Set up your Restic repo

```sh
/opt/restic-wrapper-b2/wrapper.sh init
```

### Add configuration

```sh
cd /opt/restic/conf

touch b2-key pass
chmod 600 b2-key pass

echo "b2:your-b2-bucket-name:" > repo
echo "your restic repo password" > pass
echo "your b2 app key id" > b2-id
echo "your b2 app key" > b2-key
echo "/" > dirs
echo <<'EOT' > exclude
/home/*/.cache
/tmp
/var/cache
/var/tmp
EOT
```

### Test connection

```sh
/opt/restic-wrapper-b2/wrapper.sh stats
```

### Test backup

```
/opt/restic-wrapper-b2/backup.sh
```

### Test repo check

```
/opt/restic-wrapper-b2/check.sh
```

### Install crontab

```sh
cp crontab /etc/cron.d/restic
```

Maybe change the hour, minute, and day-of-month values in the crontab too.

## Generating a restore bundle

A restore bundle contains all the files necessary to restore from the configured restic repo.

```sh
( umask 077 && sudo tar -C /opt/ -cvJf- --exclude-caches --exclude bin restic > restic-bundle-for-$HOSTNAME.tar.xz )
```

WARNING: this bundle will contain your B2 credentials and repo password! You should probably encrypt it.
