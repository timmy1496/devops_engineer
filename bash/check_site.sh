#!/usr/bin/env bash

SITE="https://example.com"
LOG_FILE="home/timmy/site_check.log"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"

if curl -Is --max-time 5 "$SITE" >/dev/null 2>&1; then
    echo "$DATE - $SITE is UP" >> "$LOG_FILE"
else
    echo "$DATE - $SITE is DOWN" >> "$LOG_FILE"
fi
