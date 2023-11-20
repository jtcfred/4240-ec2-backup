#!/bin/bash

# Set the source and destination directories
CURRENT_USER=$(whoami)
SOURCE_DIR="$HOME"  # Update with your actual home directory
DEST_USER="ec2-user"
HOST_SERVER="ec2-54-89-138-118.compute-1.amazonaws.com"
DEST_DIR="/$CURRENT_USER-backup/"  # Update with your desired backup directory on the destination server
PEM_FILE="4240-keypair.pem"  # Update with the path to your PEM file


# Create a timestamp for the backup file
TIMESTAMP=$(date "+%Y%m%d%H%M%S")

# Create a backup file name with the timestamp
BACKUP_FILE="$CURRENT_USER-backup-$TIMESTAMP"

# Archive and compress the home directory
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

# Use SFTP to transfer the backup to the destination server
sftp -i "$PEM_FILE" "$DEST_USER@$HOST_SERVER:$DEST_DIR" <<EOF
put $BACKUP_FILE
bye
EOF

# Optionally, you can delete the local backup to save space
rm "$BACKUP_FILE"

# Print a message indicating the successful backup
echo "Backup completed: $DEST_DIR/$BACKUP_FILE"