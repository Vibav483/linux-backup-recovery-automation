# Linux Backup, Recovery & Automation

A hands-on Linux project demonstrating Bash scripting, backup management, and file recovery.

## Technologies
- Linux (Ubuntu on WSL)
- Bash
- tar and gzip
- Git and GitHub
- cron and systemd

## Features
- Timestamped compressed backups
- Source directory validation and error handling
- Timestamped logging of backup events
- Configurable backup retention policy (keeps the seven newest backups)
- Automatic cleanup of older backups after successful backup creation
- Archive integrity verification and file restoration testing

## Testing
- Bash syntax validation using `bash -n`
- Backup archive readability checks using `tar -tzf`
- Restore verification by comparing restored files with the source
- Retention logic tested using nine dummy files in an isolated temporary directory; seven remained after cleanup

## Status
Core backup, retention, logging, and recovery functionality implemented and tested.
