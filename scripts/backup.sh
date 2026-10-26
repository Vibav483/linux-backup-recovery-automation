#!/bin/bash

# Linux Backup Script with Retention Policy

SOURCE_DIR="lab/source"
BACKUP_DIR="lab/backups"
LOG_DIR="lab/logs"
LOG_FILE="$LOG_DIR/backup.log"
RETENTION=7
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Create log directory
if ! mkdir -p "$LOG_DIR"; then
    echo "ERROR: Could not create log directory: $LOG_DIR"
    exit 1
fi

# Logging function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log_message "INFO - Backup started"

# Check whether the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    log_message "ERROR - Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

# Create backup directory if it does not exist
if ! mkdir -p "$BACKUP_DIR"; then
    log_message "ERROR - Could not create backup directory: $BACKUP_DIR"
    exit 1
fi

# Create compressed backup
if tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .; then
    log_message "INFO - Backup completed successfully: $BACKUP_FILE"
else
    log_message "ERROR - Backup failed"
    exit 1
fi

# Apply backup retention policy after successful backup
log_message "INFO - Applying retention policy: keeping $RETENTION backups"

RETENTION_FAILED=0

mapfile -t BACKUPS < <(
    find "$BACKUP_DIR" -maxdepth 1 -type f \
        -name 'backup_*.tar.gz' -printf '%f\n' |
    sort -r
)

if [ "${#BACKUPS[@]}" -gt "$RETENTION" ]; then
    for OLD_BACKUP in "${BACKUPS[@]:$RETENTION}"; do
        if rm -- "$BACKUP_DIR/$OLD_BACKUP"; then
            log_message "INFO - Removed old backup: $OLD_BACKUP"
        else
            log_message "ERROR - Failed to remove old backup: $OLD_BACKUP"
            RETENTION_FAILED=1
        fi
    done
else
    log_message "INFO - No old backups to remove"
fi

if [ "$RETENTION_FAILED" -eq 1 ]; then
    log_message "ERROR - Backup completed, but retention cleanup had failures"
    exit 1
fi

log_message "INFO - Backup process completed"
