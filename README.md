# Rsync Backup Script

Simple script to mirror relevant folders in home directory to external drive.

<!-- TOC orderedList:true updateOnSave:false -->

1. [Intro](#intro)
2. [Features](#features)
3. [Options](#options)
    1. [Source (-s)](#source--s)
    2. [Destination (-d)](#destination--d)
    3. [Confirm (-c)](#confirm--c)
4. [Need to know before using](#need-to-know-before-using)
5. [Usage](#usage)
6. [TODO:](#todo)

<!-- /TOC -->

# Intro

This is the core functionality of an automated backup solution I wanted for a long long time. After much thought (of using much more complicated tools), I decided on simplicity, meaning:

- File-based backup (to facilitate transparent and easy restore)
- NTFS-compatible (back up to external HDD, also for use in Windows)
- A script with least possible dependencies

I found a [great article on using rsync with NTFS drives](https://ubuntuforums.org/showthread.php?t=820425). With that as the starting point and some Googling, I came up with this script.

# Features

- Simple file-based backup for easy and transparent restore
- NTFS compatible (backup to NTFS formatted partitions and drives)
- Minimum dependencies: rsync
- Automatic backup of old versions and deleted files
  - Auto-delete backups older than 30 days
- Safe: only does a dry run by default
- Runs without sudo (for current user)
- Within destination directory, creates separate folders for each hostname+username+userID (in case multiple users back up to the same destination, and for easy identification after OS reinstallation)
- Detailed logs saved in backup folder

# Options

## Source (-s)

The source path. __Optional__.
- Defaults to current user's home directory
- Should be an absolute path
- Should not be a symlink

Mind the trailing slash (refer to how rsync handles trailing slashes).

## Destination (-d)

The destination path. __Mandatory__.
- Should be an absolute path
- Should not be a symlink

A new folder will be created within the destination path, of the form: `hostname_username-linuxUserId`. For example: `gautham-laptop_gautham-1000`

## Confirm (-c)

Performs the actual backup. __Optional__. Running without -c will do a dry run.

# Need to know before using

- Created for local use, not tested with any type of remote destinations
- Does not account for paths being symlinks
- Assumes that paths are absolute

# Usage

1. Clone repo
2. Edit filter.txt
3. Do a dry run: `bash rsyncHome.sh -s "{source_path}" -d "{destination_path}"`
4. Do an actual run by adding -c: `bash rsyncHome.sh -s "{source_path}" -d "{destination_path}" -c`
5. Optionally, add it as a cron job with preferred frequency

# TODO:

- Some solution to backup encrypted files
- Create non-backup 2-way variant for Music directory
- DONE ~~Commandline option for dry-running~~
- DONE ~~Commandline option for source and dest (and possibly other params)~~
- DONE ~~Add safety checks for source and destination paths (should exist, source should be readable and destination should be writable)~~
