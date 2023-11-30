#!/bin/bash

# Source configuration file
source "$HOME/.cloud-config.conf"

TIMESTAMP=$(date "+%Y-%m-%d__%H-%M-%S")

BACKUP_FILE="$CURRENT_USER-backup-$TIMESTAMP.tar.gz"

echo "Please wait. Your directory is being tarred..."

# Archive and compress the home directory
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

# Use scp to transfer the backup to the destination server
scp -i "$PEM_FILE" "$BACKUP_FILE" "$DEST_USER@$HOST_SERVER:$DEST_DIR"
rm "$BACKUP_FILE"
echo "Backup completed: $BACKUP_FILE"
