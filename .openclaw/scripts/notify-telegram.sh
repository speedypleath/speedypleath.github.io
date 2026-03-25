#!/bin/bash
# Send Telegram notification
# Usage: ./notify-telegram.sh "Your message here"

MESSAGE="$1"

if [ -z "$MESSAGE" ]; then
    echo "Usage: $0 <message>"
    exit 1
fi

# Send to Andrei's Telegram
openclaw message send \
    --channel telegram \
    --target 2107134288 \
    --message "$MESSAGE"
