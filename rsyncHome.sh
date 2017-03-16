#!/bin/bash

TIMESTAMP=$(date +%Y%m%d%H%M%S)
# Paths relating to script location (to find filter and log locations)
PWD="`pwd`"
FILTERFILE="$PWD/filter.txt"

SOURCE="/home/$USER/"
# Calculate destination based on current PC (hostname) and username
DESTINATION="/media/gautham/Seagate Backup Plus Drive/rsync-backups/$(hostname)_$USER-`id -u $USER`"
LOGFILE="$DESTINATION/.logs/rsync.$TIMESTAMP.log"
mkdir -p "$DESTINATION/.logs"

rsync -rltDuPv --progress --human-readable --modify-window=1 --log-file="$LOGFILE" \
--delete --backup --backup-dir="$DESTINATION/.backups" --suffix=".$TIMESTAMP.backup" \
--partial --partial-dir="$DESTINATION/.partials" \
--filter="merge $FILTERFILE" --filter=":- .gitignore" \
--exclude="$DESTINATION/.backups" --exclude="$DESTINATION/.logs" \
"$SOURCE" "$DESTINATION"

# Clean files older than 30 days
find "$DESTINATION/.backups/" -daystart -mtime +30 -type f -delete

# TODO
# - Music 2-way sync
# - How to backup encrypted content? (1. mount TrueCrypt container and backup to it; 2. backup to encrypted archive)