# Antivirus Daemon

A minimal shell script antivirus daemon that monitors a directory, quarantines flagged malicious files, and allows restoring false positives.

## Directory Structure
```text
.
├── antivirusd.sh       # Main monitoring daemon script
├── restore.sh          # Quarantined file restore tool
├── antivirus-cron.sh   # Single-pass script for cron
├── Makefile            # Build and run commands
└── README.md           # Documentation
