#!/bin/bash
# Creates or updates an album in _galleries/
# Usage: ./script/album.sh <slug> "<title>" <date> <cover_photo>
# Example: ./script/album.sh granada "Granada" 2024-04-01 granada-1.jpg

set -e

SLUG="$1"
TITLE="$2"
DATE="$3"
COVER="$4"

if [ -z "$SLUG" ] || [ -z "$TITLE" ] || [ -z "$DATE" ] || [ -z "$COVER" ]; then
  echo "Usage: $0 <slug> \"<title>\" <date> <cover_photo>"
  echo "Example: $0 granada \"Granada\" 2024-04-01 granada-1.jpg"
  exit 1
fi

FILENAME="_galleries/${SLUG}.md"

cat > "$FILENAME" << EOF
---
layout: album
title: "${TITLE}"
slug: ${SLUG}
date: ${DATE}
cover_photo: "${COVER}"
---
EOF

echo "Created: $FILENAME"
