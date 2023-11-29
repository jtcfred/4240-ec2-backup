#!/bin/bash

# Source configuration file
source "$HOME/.cloud-config.conf"

# Create a timestamp for the backup file
TIMESTAMP=$(date "+%Y-%m-%d__%H-%M-%S")

# Create a backup file name with the timestamp
BACKUP_FILE="$CURRENT_USER-backup-$TIMESTAMP.tar.gz"

echo "Please wait. Your directory is being tarred..."

# Archive and compress the home directory
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

# Use scp to transfer the backup to the destination server
scp -i "$PEM_FILE" "$BACKUP_FILE" "$DEST_USER@$HOST_SERVER:$DEST_DIR"

# Optionally, you can delete the local backup to save space
rm "$BACKUP_FILE"

# Print a message indicating the successful backup
echo "Backup completed: $BACKUP_FILE"
