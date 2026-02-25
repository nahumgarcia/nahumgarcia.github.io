#!/bin/bash
# Creates a photo post in _photos/
# Usage: ./script/photo_post.sh <date> "<photos>" "<albums>" "[caption]"
# Example: ./script/photo_post.sh 2024-04-01 "alhambra-1.jpg,alhambra-2.jpg" "granada" "Visiting the Alhambra"

set -e

DATE="$1"
PHOTOS="$2"
ALBUMS="$3"
CAPTION="$4"

if [ -z "$DATE" ] || [ -z "$PHOTOS" ]; then
  echo "Usage: $0 <date> \"<photos>\" \"<albums>\" \"[caption]\""
  echo "Example: $0 2024-04-01 \"photo1.jpg,photo2.jpg\" \"granada,spain\" \"My caption\""
  exit 1
fi

# Generate slug from first photo filename (without extension)
FIRST_PHOTO=$(echo "$PHOTOS" | cut -d',' -f1)
SLUG=$(echo "$FIRST_PHOTO" | sed 's/\.[^.]*$//')

FILENAME="_photos/${DATE}-${SLUG}.md"

# Build photos YAML
PHOTOS_YAML=""
IFS=',' read -ra PHOTO_ARR <<< "$PHOTOS"
for photo in "${PHOTO_ARR[@]}"; do
  photo=$(echo "$photo" | xargs) # trim whitespace
  alt=$(echo "$photo" | sed 's/\.[^.]*$//')
  PHOTOS_YAML="${PHOTOS_YAML}  - file: \"${photo}\"
    alt: \"${alt}\"
"
done

# Build albums YAML
ALBUMS_YAML=""
if [ -n "$ALBUMS" ]; then
  IFS=',' read -ra ALBUM_ARR <<< "$ALBUMS"
  ALBUMS_YAML="albums: ["
  for i in "${!ALBUM_ARR[@]}"; do
    album=$(echo "${ALBUM_ARR[$i]}" | xargs)
    if [ $i -gt 0 ]; then
      ALBUMS_YAML="${ALBUMS_YAML}, "
    fi
    ALBUMS_YAML="${ALBUMS_YAML}${album}"
  done
  ALBUMS_YAML="${ALBUMS_YAML}]"
fi

# Write file
cat > "$FILENAME" << EOF
---
date: ${DATE}
${ALBUMS_YAML}
photos:
${PHOTOS_YAML}---
EOF

if [ -n "$CAPTION" ]; then
  echo "$CAPTION" >> "$FILENAME"
fi

echo "Created: $FILENAME"
