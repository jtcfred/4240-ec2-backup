#!/bin/bash

# SSH into your EC2 instance and list backup files
ssh -i 4240-keypair.pem ec2-user@ec2-54-242-73-140.compute-1.amazonaws.com '
  # Specify the directory where your backup files are located on the EC2 instance
  BACKUP_DIR="/home/ec2-user"  # Update this with the actual path
  
  # List the contents of the backup directory
  echo "Contents of backup directory $BACKUP_DIR:"
  ls -lh "$BACKUP_DIR"
'
