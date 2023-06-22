# Scheduled restic backups on Google Drive

From [Fedora Magazine article](https://fedoramagazine.org/automate-backups-with-restic-and-systemd/)

- Creates snapshots on a regular basis
- Forgets snapshots based on a policy (see restic-backup.conf)
- Weekly prunes (actually cleans up data) old snapshots and checks repo integrity (a random fraction of the backup data is read to check that it is recoverable in case we'd need)
- Desktop notifications using notify-send allow to make sure backups are executed. Alerts appear in case of failure.
- Support of various backends if rclone is available.
- Services should wait for a network connection to start.
- Missed scheduled operations (ie if the system is down at the scheduled time) are kept to be executed later (unlike a cron job).
- No backup on weekends
- Easy to manually trigger a new backup at anytime (see below)

# Installation

- All unit files (`.service` and `.timer` extensions) and bash scripts (`.sh`) are to be put in `~/.config/systemd/user`
- `config/restic-backup.conf` is located in `~/.config/`.
- the `restic` command should be available system-wide or in `$PATH` (see below for download link).
- A restic repo should be created beforehead at the desired location. Here, it is a SFTP repo [(see restic docs)](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#sftp).
- restic secrets and exclude directives are in ~/restic (can be changed in `restic-backup.conf`). Don't `git add` your secrets !
- restic forget policy is set in `restic-backup.conf`. See restic docs for details.
- Backup, prune and check frequency are set in `.timer` files.

I downloaded restic from the [Github repo](https://github.com/restic/restic/releases/tag/v0.13.1) (linux Amd64 version).

# Automated use

## Start services

Running `systemctl --user daemon-reload` is necessary after changing unit files. Then :

```shell
systemctl --user enable --now restic-backup.timer
systemctl --user enable --now restic-prune.timer
systemctl --user enable --now restic-check.timer
```

## Monitor

When services are done or fail, desktop notifications are sent. 
To check everything is doing fine, or read the logs in case of a failure :

The schedulers :

```shell
systemctl --user status restic-backup.timer
systemctl --user status restic-prune.timer
systemctl --user status restic-check.timer
```

The services itself :

```shell
systemctl --user status restic-backup.service
systemctl --user status restic-prune.service
systemctl --user status restic-check.service
```

## Stop

Suspend until next reboot :

```shell
systemctl --user stop restic-backup.timer
systemctl --user stop restic-prune.timer
systemctl --user stop restic-check.timer
```

Disable it for future startups (timer will not start on boot, but can keep running now) :

```
systemctl --user disable restic-backup.timer
systemctl --user disable restic-prune.timer
systemctl --user disable restic-check.timer
```

# Manual use

## Force a backup now

```shell
systemctl --user start restic-backup.service
```

## Force a prune + check now

```shell
systemctl --user start restic-prune.service
```

## Force a prune + check now

```shell
systemctl --user start restic-check.service
```


## Refresh a Gdrive token

```shell
rclone config update gdrive-backup config_refresh_token true
```

## Unlock the repo

If an operation stopped unexpectedly, the repo can sometimes stay locked.

```shell
restic -r rclone:gdrive-backup:restic --password-file ~/restic/cred-gdrive.txt unlock
```

# Restoring files

## Mount the repo

The repo can be easily explored by mounting it with FUSE :

```shell
mkdir -p /tmp/restic
restic -r rclone:gdrive-backup:restic --password-file ~/restic/cred-gdrive.txt mount /tmp/restic
cd /tmp/restic/snapshots
```
