                           #!/bin/bash

# Set the path to the backup file
BACKUP_FILE="/home/ec2-user/jcozzi-backup-2023-11-28__20-21-45.tar.gz"  # Update>

# Extract the contents of the backup file to a temporary directory
TMP_DIR="/tmp/backup_contents"
mkdir -p "$TMP_DIR"
tar -xzvf "$BACKUP_FILE" -C "$TMP_DIR"

# List the contents of the temporary directory
echo "Contents of the backup file:"
ls -l "$TMP_DIR"

# Clean up the temporary directory
rm -r "$TMP_DIR"

echo "Backup contents listing completed."
