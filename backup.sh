restic backup -r sftp:allera@132.166.68.152:/home/allera/restic \
	--password-file $PASSWORD_FILE  \
	--verbose \
	--tag systemd.timer $BACKUP_EXCLUDES $BACKUP_PATHS && \
restic forget \
	-r sftp:allera@132.166.68.152:/home/allera/restic \
	--password-file $PASSWORD_FILE \
	--verbose \
	--tag systemd.timer \
	--group-by "paths,tags" \
	--keep-last $RETENTION_NUM \
	--keep-hourly $RETENTION_HOURS \
	--keep-daily $RETENTION_DAYS \
	--keep-weekly $RETENTION_WEEKS \
	--keep-monthly $RETENTION_MONTHS \
	--keep-yearly $RETENTION_YEARS
