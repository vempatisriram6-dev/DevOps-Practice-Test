 Automated Backup System (Bash Script Project)

A simple **Bash-based backup automation system** that helps you take automatic backups, verify them, and clean up old ones — all in one script.

---

 A. Project Overview

What Does This Script Do?
This project automates the process of taking backups of important folders.  
It:
- Compresses your folder into a `.tar.gz` backup file  
- Generates a SHA256 checksum to ensure file integrity  
- Excludes unnecessary folders like `.git`, `node_modules`, and `.cache`  
- Automatically deletes old backups based on rotation rules  
- Logs all backup and verification details in a `backup.log` file

   Why It’s Useful
Manually creating backups is time-consuming and prone to mistakes.  
This script automates the entire process — from compression to verification — ensuring your backups are consistent, verified, and space-efficient.

---
 B. How to Use It

Step 1: Requirements
Make sure you have:
- **Git Bash** (for Windows) or any **Linux/Mac terminal**
- The commands `tar` and `sha256sum` installed (these come preinstalled in most systems)

---

Step 2: Download or Clone This Project
```bash
git clone https://github.com/vempatisriram6-dev/DevOps-Practice-Test.git
cd backup-system

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
