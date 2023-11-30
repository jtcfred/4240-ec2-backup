#!/bin/bash

# Source hidden configuration file
source "$HOME/.cloud-config.conf"

# Check if a filename is provided as a command line argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Extract the filename from the command line argument
FILENAME="$1"

# Use scp to download the file from the EC2 instance to the local machine
scp -i "$PEM_FILE" "$DEST_USER@$HOST_SERVER:$DEST_DIR/$FILENAME" .

# Print a message indicating the successful download
echo "Download completed: $FILENAME"
