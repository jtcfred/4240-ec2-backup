#!/bin/bash

# Specify the directory where the backup files are located
BACKUP_DIR="$YOUR-DIR"

# Find the latest backup file in the directory
LATEST_BACKUP=$(find "$BACKUP_DIR" -type f -name "*-backup-*" | sort -r | head >

# Check if a backup file was found
if [ -n "$LATEST_BACKUP" ]; then
    echo "Listing files from the backup file: $LATEST_BACKUP"
    tar -tzf "$LATEST_BACKUP"
else
    echo "No backup files found in $BACKUP_DIR"
fi
