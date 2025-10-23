#!/usr/bin/env bash

# --- CONFIG ---
PROCESSES=(
  "sshd:/data/data/com.termux/files/usr/bin/sshd"
  "cron:termux-job-scheduler"      # Example placeholder
  "httpserver:python3 -m http.server 8080"  # Test server
)
CHECK_INTERVAL=30
LOG_DIR="$HOME/sysmon_logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$HOME/sysmon/sysmon_master.log"
# Optional notifications
USE_TERMUX_NOTIFY=true
# Optional Telegram (fill to use)
TG_BOT_TOKEN=""
TG_CHAT_ID=""
# --- END CONFIG ---

notify() {
  MSG="$1"
  echo "$(date '+%F %T') - $MSG" >> "$LOG_DIR/monitor.log"
  if [ "$USE_TERMUX_NOTIFY" = true ] && command -v termux-notification >/dev/null 2>&1 ; then
    termux-notification --title "SysMon" --content "$MSG"
  fi
  if [ -n "$TG_BOT_TOKEN" ] && [ -n "$TG_CHAT_ID" ]; then
    curl -s -X POST "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
      -d chat_id="${TG_CHAT_ID}" -d text="$MSG" >/dev/null 2>&1
  fi
}

while true; do
  # 1) write snapshot
  ~/sysmon/sys_health.sh "$LOG_DIR/snapshot_$(date '+%F_%T').txt"

  # 2) check all processes
  for entry in "${PROCESSES[@]}"; do
    NAME="${entry%%:*}"
    CMD="${entry#*:}"
    ~/sysmon/restart_if_dead.sh "$NAME" "$CMD"
  done

  sleep "$CHECK_INTERVAL"
done
