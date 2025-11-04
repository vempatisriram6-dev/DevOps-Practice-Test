#!/bin/bash

# ================================
# 🔒 Automated Backup Script
# ================================

CONFIG_FILE="./backup.config"

# Load configuration
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "[ERROR] Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Function for both logging and displaying output
log() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Start backup
START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
TIMESTAMP=$(date '+%Y-%m-%d-%H%M')
BACKUP_FILE="$BACKUP_DESTINATION/backup-$TIMESTAMP.tar.gz"
CHECKSUM_FILE="$BACKUP_FILE.sha256"

log "[INFO] Backup started at $START_TIME"

# Ensure destination exists
mkdir -p "$BACKUP_DESTINATION"

# Perform backup
tar --exclude="$BACKUP_DESTINATION" $(for p in ${EXCLUDE_PATTERNS//,/ }; do echo "--exclude=$p"; done) \
    -czf "$BACKUP_FILE" "$BACKUP_SOURCE" 2>>"$LOG_FILE"

# Check if tar succeeded
if [ $? -eq 0 ]; then
    sha256sum "$BACKUP_FILE" > "$CHECKSUM_FILE"
    log "[SUCCESS] Backup completed: $BACKUP_FILE"
else
    log "[ERROR] Backup failed!"
    exit 1
fi

# Cleanup old backups
log "[INFO] Cleaning up old backups..."
find "$BACKUP_DESTINATION" -name "backup-*.tar.gz" -mtime +$DAILY_KEEP -delete
log "[INFO] Cleanup completed ✅"

# End of script
