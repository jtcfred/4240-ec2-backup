#!/bin/bash

# SSH into your EC2 instance and list backup files
ssh -i /Users/dhruvipatel/Downloads/4240-ec2-backup-main/4240-keypair.pem ec2-user@ec2-3-85-77-13.compute-1.amazonaws.com << EOF
  # Specify the directory where your backup files are located on the EC2 instance
  BACKUP_DIR="/home/ec2-user"  # Update this with the actual path
  
  # List the contents of the backup directory
  echo "Contents of backup directory $BACKUP_DIR:"
  ls -lh "$BACKUP_DIR"
EOF
