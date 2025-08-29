# Disk Space Alert

Simple Bash project that checks root filesystem disk usage and alerts when usage exceeds a configurable threshold.

## Contents
- `disk_alert.sh` — main Bash script
- `config.example.env` — example environment variables
- `logs/` — log output directory (created at runtime)
- `.github/workflows/ci.yml` — (optional) simple CI that lints the script with shellcheck

## Usage
1. Clone the repo.
2. Copy `config.example.env` to `.env` and edit `THRESHOLD` and optional `ALERT_CMD`.
3. Make the script executable:
   ```bash
   chmod +x disk_alert.sh
   ```
4. Run manually:
   ```bash
   ./disk_alert.sh
   ```
5. (Optional) Install as a cron job to run every 5 minutes:
   ```bash
   crontab -e
   # add the line:
   */5 * * * * /path/to/disk-space-alert/disk_alert.sh >/dev/null 2>&1
   ```

## Alerting
- By default the script writes to `logs/disk_alert.log`.
- You can set `ALERT_CMD` in `.env` to a shell command that will be executed with the alert message appended.
  Example:
  ```bash
  ALERT_CMD="mail -s 'Disk Alert' admin@example.com"
  ```

## License
MIT
