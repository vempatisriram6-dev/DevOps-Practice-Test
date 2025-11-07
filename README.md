             Automated Backup System (Bash Script Project)

A simple Bash-based backup automation system that helps you take automatic backups, verify them, and clean up old ones — all with one command.

It’s perfect for students, developers, or DevOps learners who want to automate local backups and understand backup rotation concepts.

🧩 A. Project Overview
🧠 What Does This Script Do?

This project automates the backup of a chosen folder by:

Compressing the target directory into a .tar.gz archive

Generating a SHA256 checksum to ensure file integrity

Skipping unwanted folders like .git, node_modules, and .cache

Automatically rotating backups (keeping only the latest 7 daily, 4 weekly, and 3 monthly backups)

Logging every backup operation into logs/backup.log

💡 Why It’s Useful

Manual backups are time-consuming and prone to human error.
This automation script:

Keeps your files safe automatically

Saves disk space using rotation

Provides clear logs for troubleshooting

Can be easily customized for any system

⚙️ B. How to Use It (Step-by-Step)
🪜 Step 1: Prerequisites

Make sure you have:

Git Bash on Windows or Terminal on Linux/Mac

tar and sha256sum utilities (installed by default on most systems)

🪜 Step 2: Clone the Repository
git clone https://github.com/vempatisriram6-dev/DevOps-Practice-Test.git
cd backup-system

🪜 Step 3: Configure the Backup

Open the file backup.config and update these paths:

BACKUP_SOURCE="/c/Users/vempa/Desktop/test_folder"
BACKUP_DESTINATION="/c/Users/vempa/Desktop/backups"
LOG_FILE="./logs/backup.log"

EXCLUDE_PATTERNS=".git,node_modules,.cache"

DAILY_KEEP=7
WEEKLY_KEEP=4
MONTHLY_KEEP=3


You can adjust retention numbers or excluded folders anytime.

🪜 Step 4: Run the Backup
./backup.sh


This will:

Create a new backup in your destination folder

Save logs in logs/backup.log

Display success/failure messages in the terminal

🪜 Step 5: Verify the Backup

To verify that the backup was created and matches its checksum:

./verify_backup.sh backup-YYYY-MM-DD-HHMM.tar.gz


If verification passes, you’ll see:

[SUCCESS] Checksum verified successfully ✅

🪜 Step 6: Check Logs

All activities (start, success, cleanup, errors) are stored here:

logs/backup.log


Example log:

[INFO] Backup started at 2025-11-03 19:30:00
[SUCCESS] Backup completed: /c/Users/vempa/Desktop/backups/backup-2025-11-03-1930.tar.gz
[INFO] Cleanup completed ✅

🪜 Step 7: Folder Structure
backup-system/
├── backup.sh               # Main script
├── verify_backup.sh        # Backup verification script
├── backup.config           # Configuration file
├── logs/
│   └── backup.log          # Log file
├── screenshots/
│   └── backup-output.png   # Example output
└── README.md               # Documentation

🪜 Step 8: Example Output (Screenshot)

📸 Backup output shown in Git Bash:

🪜 Step 9: Automation (Optional)

You can automate this with Windows Task Scheduler or Linux cron jobs.

Example cron entry (Linux):

0 2 * * * /path/to/backup-system/backup.sh


This runs the backup every day at 2 AM.

🧮 C. How It Works
🔁 Rotation Algorithm

The script:

Keeps only the 7 most recent daily backups

Keeps only the 4 most recent weekly backups

Keeps only the 3 most recent monthly backups

Deletes older ones automatically

This saves disk space while ensuring recovery options.

🔐 Checksum Creation

For every backup, a .sha256 file is created:

sha256sum backup-2025-11-03-1930.tar.gz > backup-2025-11-03-1930.tar.gz.sha256


You can recheck integrity anytime using:

sha256sum -c backup-2025-11-03-1930.tar.gz.sha256

🧱 D. Design Decisions
Why This Approach?

Simple and portable Bash scripting

No dependency on third-party tools

Ideal for beginners learning Linux + DevOps automation

Challenges Faced

Ensuring Windows compatibility for Git Bash

Managing path conversions (/c/Users/... vs C:\Users\...)

Proper logging and simultaneous screen display

How They Were Solved

Used consistent POSIX-style paths

Implemented dual logging using tee command

Added checksum validation to verify backup integrity

🧪 E. Testing
✅ Functional Tests
Test	Description	Result
Backup creation	Run ./backup.sh	✅ Success
Backup rotation	Created multiple backups	✅ Old backups removed
Checksum verification	Using verify_backup.sh	✅ Passed
Exclude patterns	.git, node_modules, .cache	✅ Ignored
Error handling	Tried invalid source folder	✅ Graceful error
Example Backup Log:
[INFO] Backup started at 2025-11-03 19:30:00
[SUCCESS] Backup completed: /c/Users/vempa/Desktop/backups/backup-2025-11-03-1930.tar.gz
[INFO] Rotation check complete – old backups removed
[INFO] Backup finished successfully ✅

⚠️ F. Known Limitations

Script doesn’t handle remote/cloud backups yet (local only)

tar compression speed may be slow for very large files

Rotation works by filename date, not by file size

No real-time progress bar (can be added later)

🚀 Future Improvements

Add remote upload support (AWS S3 / Google Drive)

Add email notifications after each backup

Add restore.sh to unpack backups automatically

Integrate with cron logs or systemd timers

💬 Example  Summary
Command	Description
./backup.sh	Create a new backup
./verify_backup.sh backup-file.tar.gz	Verify checksum
cat logs/backup.log	View logs
ls /c/Users/vempa/Desktop/backups	View all backups
./push_all.sh	(Optional) Commit + Push to GitHub


	Author

V. Sriram
💼 GitHub: @vempatisriram6-dev

📘 Project: DevOps Practice Test Repository

