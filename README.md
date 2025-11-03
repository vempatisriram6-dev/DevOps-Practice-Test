 Automated Backup System

A simple automated backup script that:
- Compresses your important directories
- Stores backups with timestamps
- Logs success/failure messages
- Optionally verifies backups using checksums

 Files
- `backup.sh` — main backup script  
- `backup.config` — configuration file  
- `verify_backup.sh` — backup verification tool  
- `logs/backup.log` — stores backup logs

 Usage
```bash
./backup.sh
./verify_backup.sh <backup-file>
