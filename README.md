# Rsync Backup for Linux Home Directory

Simple script to mirror relevant folders in home directory to external drive. This is the core functionality of an automated backup solution I wanted for a long long time. After much thought (of using much more complicated tools), I decided on simplicity, meaning:

- File-based backup (to facilitate transparent and easy restore)
- NTFS-compatible (back up to external HDD, also for use in Windows)
- Portable script with least possible dependencies

So I came up with this script, which runs off of pure rsync and basic bash commands. Some "features":

- Runs without sudo, for current user
- Within destination directory, creates separate folders for each hostname+username+userID (in case multiple users back up to the same destination, and for easy identification after OS reinstalls)
- Simple file-based backup for easy restore
- NTFS compatible
- Simple old version and deleted file backups
  - Delete backups older than 30 days

## Usage

1. Clone repo
2. Edit filter.txt
3. Change source and destination directories in script
4. Edit script to add --dry-run flag and test out (thoroughly!!)
5. Remove --dry-run and run script
6. Optionally, add it as a cron job with reasonable frequency

## Notes

- Created for local use, not tested with any type of remote destinations

## TODO:

- Commandline option for dry-running
- Commandline option for source and dest (and possibly other params)
- Some solution to backup encrypted files
- Create non-backup 2-way variant for Music directory