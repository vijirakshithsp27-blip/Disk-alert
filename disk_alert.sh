#!/usr/bin/env bash
# disk_alert.sh - simple disk usage alert script
# Usage: ./disk_alert.sh
set -u

# Load environment variables from .env if present
if [ -f ".env" ]; then
  # shellcheck disable=SC1091
  . ./.env
fi

# Defaults (can be overridden in .env)
THRESHOLD=${THRESHOLD:-80}        # percent
LOG_DIR=${LOG_DIR:-"./logs"}
LOG_FILE="$LOG_DIR/disk_alert.log"
ALERT_CMD=${ALERT_CMD:-}          # optional alert command (e.g. mail, curl to webhook)

mkdir -p "$LOG_DIR"

# Check disk usage for root filesystem '/'
USAGE_RAW=$(df --output=pcent / | tail -n1)
# Remove trailing % and spaces
USAGE=$(echo "$USAGE_RAW" | tr -dc '0-9')

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname)
MESSAGE="$TIMESTAMP - $HOSTNAME - disk usage: ${USAGE}% (threshold ${THRESHOLD}%)"

if [ -z "$USAGE" ]; then
  echo "$TIMESTAMP - ERROR: Could not determine disk usage" >> "$LOG_FILE"
  exit 1
fi

if [ "$USAGE" -ge "$THRESHOLD" ]; then
  echo "$MESSAGE - WARNING" | tee -a "$LOG_FILE"
  # If ALERT_CMD is set, pipe the message to it
  if [ -n "$ALERT_CMD" ]; then
    # append the message to the alert command's stdin
    echo "$MESSAGE" | bash -c "$ALERT_CMD" || echo "$TIMESTAMP - ALERT_CMD failed" >> "$LOG_FILE"
  fi
  exit 0
else
  echo "$MESSAGE - OK" >> "$LOG_FILE"
  exit 0
fi
