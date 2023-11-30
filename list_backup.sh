#!/bin/bash

# SSH into your EC2 instance and list backup files
<<<<<<< HEAD
#!/bin/bash

# Load cloud configuration from .cloud-config.conf
source .cloud-config.conf

# SSH into your EC2 instance and list only tar.gz files in the backup directory
ssh -i "$PEM_FILE" "$DEST_USER@$HOST_SERVER" '
  # List only tar.gz files in the backup directory
  echo "Tar.gz files in backup directory $DEST_DIR:"
  find "$DEST_DIR" -type f -name "*.tar.gz"
'
=======
ssh -i /Users/simonhughes/Desktop/CPSC4240/4240-keypair.pem ec2-user@ec2-54-242-73-140.compute-1.amazonaws.com
# Specify the directory where your backup files are located on the EC2 instance
BACKUP_DIR="/home/ec2-user"  # Update this with the actual path

# List the contents of the backup directory
echo "Contents of backup directory $BACKUP_DIR:"
ls -lh "$BACKUP_DIR"
>>>>>>> 09373ad (Added tool interface)
