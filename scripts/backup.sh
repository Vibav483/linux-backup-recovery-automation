#!/bin/bash

# Basic Linux Backup Script

SOURCE_DIR="lab/source"
BACKUP_DIR="lab/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Check whether the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

# Create backup directory if it does not exist
if ! mkdir -p "$BACKUP_DIR"; then
    echo "ERROR: Could not create backup directory: $BACKUP_DIR"
    exit 1
fi

# Create compressed backup
if tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .; then
    echo "Backup completed successfully: $BACKUP_FILE"
else
    echo "ERROR: Backup failed!"
    exit 1
fi
