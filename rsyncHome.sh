#!/bin/bash

# Set initial defaults for parameters
SOURCE="/"
DESTINATION="/"
REAL_RUN="no"

# Check if commandline parameters are passed. If so, set variables
while getopts s:d:c opts; do
    case $opts in
        s)
            SOURCE="$OPTARG"
            ;;
        d)
            DESTINATION="$OPTARG"
            ;;
        c)
            REAL_RUN="yes"
            ;;
    esac
done

# Exit if destination is not provided
if [ "$DESTINATION" == "/" ]; then
    echo "Destination needs to be provided: -d \"destination_path\""
    exit 1
fi

# Default to current user's' home directory if no source path is specified
if [ "$SOURCE" == "/" ]; then
    SOURCE="/home/$USER/"
    echo "Source path not provided. Using home directory: \"$SOURCE\""
    echo
fi

# TODO Symlink check instructions: https://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
# TODO Canonicalize paths instructions (for relative path support): https://stackoverflow.com/questions/32857392/bash-check-if-a-relative-path-exists

# Check if source directory exists
if [ ! -d "$SOURCE" ]; then
    echo "Directory \"$SOURCE\" does not exist"
    exit 1
fi

# Check if source directory is readable
if [ ! -r "$SOURCE" ]; then
    echo "Directory \"$SOURCE\" is not readable"
    exit 1
fi

# Check if destination directory exists
if [ ! -d "$DESTINATION" ]; then
    echo "Directory \"$DESTINATION\" does not exist"
    exit 1
fi

# Check if destination directory is writable
if [ ! -r "$DESTINATION" ]; then
    echo "Directory \"$DESTINATION\" is not writable"
    exit 1
fi

# Append current PC (hostname) and username to destination
DESTINATION="${DESTINATION%/}/$(hostname)_$USER-`id -u $USER`"

# Set logfile location in the destination
TIMESTAMP=$(date +%Y%m%d%H%M%S)
LOGFILE="$DESTINATION/.logs/rsync.$TIMESTAMP.log"
mkdir -p "$DESTINATION/.logs"

FILTERFILE="`pwd`/filter.txt"

do_rsync() {
    rsync -rltDuPv --progress --human-readable --modify-window=1 --log-file="$LOGFILE" \
    --delete --backup --backup-dir="$DESTINATION/.backups" --suffix=".$TIMESTAMP.backup" \
    --partial --partial-dir="$DESTINATION/.partials" \
    --filter="merge $FILTERFILE" --filter=":- .gitignore" \
    --exclude="$DESTINATION/.backups" --exclude="$DESTINATION/.logs" \
    "$SOURCE" "$DESTINATION"

    # Clean files older than 30 days
    find "$DESTINATION/.backups/" -daystart -mtime +30 -type f -delete
}

do_rsync_dry_run() {
    rsync -rltDuPv --progress --dry-run --human-readable --modify-window=1 --log-file="$LOGFILE" \
    --delete --backup --backup-dir="$DESTINATION/.backups" --suffix=".$TIMESTAMP.backup" \
    --partial --partial-dir="$DESTINATION/.partials" \
    --filter="merge $FILTERFILE" --filter=":- .gitignore" \
    --exclude="$DESTINATION/.backups" --exclude="$DESTINATION/.logs" \
    "$SOURCE" "$DESTINATION"

    # Clean files older than 30 days
    find "$DESTINATION/.backups/" -daystart -mtime +30 -type f -delete
}

echo "Source:       $SOURCE"
echo "Destination:  $DESTINATION"
echo
if [ $REAL_RUN == "yes" ]; then
    echo "Starting backup..."
    echo
    do_rsync
else
    echo "Starting dry run..."
    echo
    do_rsync_dry_run
    echo
    echo "Run command with -c to backup"
fi

# TODO
# - Music 2-way sync
# - How to backup encrypted content? (1. mount TrueCrypt container and backup to it; 2. backup to encrypted archive)