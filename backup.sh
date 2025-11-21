#!/bin/bash

# Load configuration
source ./backup.config

TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
BACKUP_FILE="$BACKUP_DESTINATION/backup-$TIMESTAMP.tar.gz"
CHECKSUM_FILE="$BACKUP_FILE.sha256"
EMAIL_FILE="email.txt"
SNAPSHOT_FILE="snapshot.info"

log() {
    echo "[$1] $2" | tee -a "$LOG_FILE"
}

# --------------------------
# 1. LIST BACKUPS
# --------------------------
if [[ "$1" == "--list" ]]; then
    log "INFO" "Listing available backups..."
    ls -lh "$BACKUP_DESTINATION"/*.tar.gz 2>/dev/null || echo "No backups found."
    exit 0
fi


# --------------------------
# 2. RESTORE BACKUP
# --------------------------
if [[ "$1" == "--restore" ]]; then
    BACKUP_TO_RESTORE="$2"

    if [[ ! -f "$BACKUP_TO_RESTORE" ]]; then
        log "ERROR" "Backup file not found!"
        exit 1
    fi

    if [[ "$3" == "--to" ]]; then
        RESTORE_DIR="$4"
    else
        log "ERROR" "Missing --to path"
        exit 1
    fi

    mkdir -p "$RESTORE_DIR"
    tar -xzf "$BACKUP_TO_RESTORE" -C "$RESTORE_DIR"
    log "SUCCESS" "Backup restored to $RESTORE_DIR"

    echo "Restore Success: $BACKUP_TO_RESTORE → $RESTORE_DIR" > "$EMAIL_FILE"
    exit 0
fi


# --------------------------
# 3. INCREMENTAL BACKUP
# --------------------------
if [[ "$1" == "--incremental" ]]; then
    log "INFO" "Performing incremental backup..."

    tar --listed-incremental="$SNAPSHOT_FILE" \
        -czf "$BACKUP_FILE" "$BACKUP_SOURCE"

    sha256sum "$BACKUP_FILE" > "$CHECKSUM_FILE"
    log "SUCCESS" "Incremental backup created: $BACKUP_FILE"

    echo "Incremental backup completed: $BACKUP_FILE" > "$EMAIL_FILE"
    exit 0
fi


# --------------------------
# 4. SPACE CHECK BEFORE BACKUP
# --------------------------
SOURCE_SIZE=$(du -sm "$BACKUP_SOURCE" | cut -f1)
FREE_SPACE=$(df -m "$BACKUP_DESTINATION" | awk 'NR==2 {print $4}')

if (( FREE_SPACE < SOURCE_SIZE )); then
    log "ERROR" "Not enough disk space! Required: ${SOURCE_SIZE}MB Available: ${FREE_SPACE}MB"
    echo "Backup failed due to low disk space." > "$EMAIL_FILE"
    exit 1
fi

log "INFO" "Disk space check passed."


# --------------------------
# 5. EXCLUDE PATTERNS CLEANUP
# --------------------------
EXCLUDES=()
IFS=',' read -ra ITEMS <<< "$EXCLUDE_PATTERNS"
for item in "${ITEMS[@]}"; do
    EXCLUDES+=(--exclude="$item")
done


# --------------------------
# 6. CREATE FULL BACKUP
# --------------------------
log "INFO" "Starting full backup..."

tar -czf "$BACKUP_FILE" "${EXCLUDES[@]}" "$BACKUP_SOURCE"

if [[ $? -ne 0 ]]; then
    log "ERROR" "Backup failed!"
    echo "Backup failed." > "$EMAIL_FILE"
    exit 1
fi

log "SUCCESS" "Backup created: $BACKUP_FILE"


# --------------------------
# 7. GENERATE CHECKSUM
# --------------------------
sha256sum "$BACKUP_FILE" > "$CHECKSUM_FILE"
log "INFO" "Checksum file created."


# --------------------------
# 8. ROTATION LOGIC
# --------------------------
log "INFO" "Starting rotation cleanup..."

# Daily (keep 7)
ls -1t "$BACKUP_DESTINATION"/backup-*.tar.gz 2>/dev/null | sed -e '1,7d' | xargs -r rm -f

# Weekly (keep 4)
find "$BACKUP_DESTINATION" -name "backup-*-01-*.tar.gz" | sort -r | sed -e '1,4d' | xargs -r rm -f

# Monthly (keep 3)
find "$BACKUP_DESTINATION" -name "backup-*-*-01-*.tar.gz" | sort -r | sed -e '1,3d' | xargs -r rm -f

log "INFO" "Rotation complete."


# --------------------------
# 9. EMAIL NOTIFICATION (SIMULATED)
# --------------------------
echo "Backup Completed Successfully at $(date)" > "$EMAIL_FILE"


# --------------------------
# 10. DONE
# --------------------------
log "SUCCESS" "Backup process completed!"
exit 0
