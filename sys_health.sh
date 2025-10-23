#!/usr/bin/env bash
# sys_health.sh - print a short snapshot of system health

OUTFILE=${1:-/sdcard/sysmon_last.txt}   # default location (change if you want)
DATE="$(date '+%F %T %z')"

{
  echo "=== SYS SNAPSHOT: $DATE ==="
  echo ""
  echo "UPTIME & LOAD:"
  uptime
  echo ""
  echo "MEMORY:"
  free -h
  echo ""
  echo "TOP 5 PROCS (by %MEM):"
  ps aux --sort=-%mem | awk 'NR==1{print $0} NR>1 && NR<=6{print $0}'
  echo ""
  echo "DISK USAGE:"
  df -h
  echo ""
  echo "LAST KERNEL LOGS:"
  dmesg | tail -n 12
  echo ""
} > "$OUTFILE"
