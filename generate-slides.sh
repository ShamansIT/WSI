#!/usr/bin/env bash
# Scans assets/ for image files and generates slides.json
# Usage: ./generate-slides.sh

set -euo pipefail
cd "$(dirname "$0")"

output="slides.json"

files=$(find assets -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.svg" \) \
  ! -name "404.png" ! -name ".gitkeep" \
  | sed 's|^assets/||' \
  | sort)

if [ -z "$files" ]; then
  printf '[]' > "$output"
else
  printf '[' > "$output"
  first=true
  while IFS= read -r file; do
    if [ "$first" = true ]; then
      first=false
    else
      printf ',' >> "$output"
    fi
    printf '"%s"' "$file" >> "$output"
  done <<< "$files"
  printf ']' >> "$output"
fi

count=$(echo "$files" | grep -c . || true)
echo "Generated slides.json with $count slides"
