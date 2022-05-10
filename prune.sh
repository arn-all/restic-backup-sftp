restic prune -r sftp:allera@132.166.68.152:/home/allera/restic \
	 --password-file $PASSWORD_FILE && \
restic check -r sftp:allera@132.166.68.152:/home/allera/restic \
	 --password-file $PASSWORD_FILE
