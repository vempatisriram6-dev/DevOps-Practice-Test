
# ----------------------------------------------------
# VERIFY BACKUP
# ----------------------------------------------------
verify_backup() {
    local BACKUP_FILE="$1"
    local CHECKSUM_FILE="$BACKUP_FILE.sha256"

    echo "🔍 Verifying backup integrity..."

    # 1️⃣ Check if checksum file exists
    if [ ! -f "$CHECKSUM_FILE" ]; then
        echo "❌ Checksum file missing!"
        return 1
    fi

    # 2️⃣ Recalculate checksum and compare
    local NEW_SUM
    NEW_SUM=$(sha256sum "$BACKUP_FILE" | awk '{print $1}')
    local OLD_SUM
    OLD_SUM=$(awk '{print $1}' "$CHECKSUM_FILE")

    if [ "$NEW_SUM" != "$OLD_SUM" ]; then
        echo "❌ Checksum mismatch! Backup file may be corrupted."
        return 1
    fi

    # 3️⃣ Test extraction of a random file
    tar -tzf "$BACKUP_FILE" > /tmp/filelist.txt 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "❌ Failed to read archive file list!"
        return 1
    fi

    local TEST_FILE
    TEST_FILE=$(shuf -n 1 /tmp/filelist.txt)

    if [ -z "$TEST_FILE" ]; then
        echo "❌ Archive is empty!"
        return 1
    fi

    tar -xzf "$BACKUP_FILE" -C /tmp "$TEST_FILE" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "❌ Failed to extract test file!"
        return 1
    fi

    echo "✅ Verification SUCCESS — backup is valid!"
    return 0
}
