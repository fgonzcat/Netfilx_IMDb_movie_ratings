#!/usr/bin/env bash

# Absolute path to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Repo root (scripts/ is one level down)
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"


INPUT="$REPO_ROOT/data/codes_one_by_one.txt"
TARGET="$REPO_ROOT/website_jupyter_book/netflix_codes.md"

while read -r code url name; do
    # Safety: skip empty or malformed lines
    [[ -z "$code" ]] && continue
    [[ ! "$code" =~ ^[0-9]+$ ]] && continue

    # Check if the genre code already exists
    if grep -q "genre/${code} " "$TARGET"; then
        echo "🔴 Skipping existing code: $code"
        echo "   --> $(grep "genre/${code} " "$TARGET") "
    else
        echo "🟢 Adding new code: $code"
        echo "   --> | ${name/\"/} | https://www.netflix.com/browse/genre/${code} | >> $TARGET"
        echo "| ${name//\"/} | https://www.netflix.com/browse/genre/${code} |" >> "$TARGET"
    fi
done < "$INPUT"

