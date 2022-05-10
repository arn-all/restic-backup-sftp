restic --verbose -r sftp:allera@132.166.68.152:/home/allera/restic \
    --password-file=$HOME/restic/pass_NAS.txt check \
    --read-data-subset=1.0%