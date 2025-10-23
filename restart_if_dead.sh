#!/usr/bin/env bash

PR_NAME="$1"
START_CMD="$2"
LOG="$HOME/sysmon/sysmon_restart.log"

# Check arguments
if [ -z "$PR_NAME" ] || [ -z "$START_CMD" ]; then
  echo "Usage: $0 <proc_name_search> <start_command>" >> "$LOG"
  exit 2
fi

# Check if process is running
if ! pgrep -f "$PR_NAME" >/dev/null 2>&1; then
  echo "$(date '+%F %T') - $PR_NAME not found. Starting: $START_CMD" >> "$LOG"
  nohup bash -c "$START_CMD" >> "$HOME/sysmon/sysmon_${PR_NAME}.out" 2>&1 &
  sleep 1
  PIDS=$(pgrep -af "$PR_NAME" | awk '{print $1}')
  echo "$(date '+%F %T') - Started, pid(s): $PIDS" >> "$LOG"
else
  echo "$(date '+%F %T') - $PR_NAME running (no action)" >> "$LOG"
fi

