#!/bin/bash

source "$HOME/.cloud-config.conf"

# SSH into your EC2 instance and list only tar.gz files in the backup directory
ssh -i "$PEM_FILE" ec2-user@ec2-54-161-37-214.compute-1.amazonaws.com '
  # Specify the directory where your backup files are located on the EC2 instance
  BACKUP_DIR="/home/ec2-user"  # Update this with the actual path

  # List only tar.gz files in the backup directory
  echo "Tar.gz files in backup directory $BACKUP_DIR:"
  find "$BACKUP_DIR" -type f -name "*.tar.gz"
  '
