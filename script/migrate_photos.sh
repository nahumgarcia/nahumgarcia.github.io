#!/bin/bash
# Migrates existing gallery system to new photo feed system
# - Moves photos from subdirectories to flat assets/photos/
# - Creates individual _photos/ posts
# - Updates _galleries/ to new album format
set -e

PHOTOS_DIR="assets/photos"
PHOTOS_COLLECTION="_photos"

mkdir -p "$PHOTOS_COLLECTION"

echo "=== Migrating Granada ==="
# Move granada photos to flat structure
for f in "$PHOTOS_DIR/2023-04-01-granada"/granada-*.jpg; do
  [ -f "$f" ] || continue
  basename=$(basename "$f")
  cp "$f" "$PHOTOS_DIR/$basename"
  echo "  Copied: $basename"
done

# Create individual posts for each granada photo
for i in $(seq 1 14); do
  FILE="granada-${i}.jpg"
  if [ -f "$PHOTOS_DIR/$FILE" ]; then
    # Read description from .md file if it exists
    DESC_FILE="$PHOTOS_DIR/2023-04-01-granada/granada-${i}.md"
    ALT="granada-${i}"
    if [ -f "$DESC_FILE" ]; then
      ALT=$(cat "$DESC_FILE")
    fi

    cat > "$PHOTOS_COLLECTION/2024-04-01-granada-${i}.md" << EOF
---
date: 2024-04-01
albums: [granada]
photos:
  - file: "granada-${i}.jpg"
    alt: "${ALT}"
---
EOF
    echo "  Created: _photos/2024-04-01-granada-${i}.md"
  fi
done

# Update granada album
cat > "_galleries/granada.md" << EOF
---
layout: album
title: "Granada"
slug: granada
date: 2024-04-01
cover_photo: "granada-1.jpg"
---
EOF
echo "  Updated: _galleries/granada.md"
# Remove old gallery file
rm -f "_galleries/2023-04-01-granada.md"
echo "  Removed: _galleries/2023-04-01-granada.md"

echo ""
echo "=== Migrating Mexico ==="
# Move mexico photos to flat structure
for f in "$PHOTOS_DIR/mexico"/mexico-*.jpg; do
  [ -f "$f" ] || continue
  basename=$(basename "$f")
  cp "$f" "$PHOTOS_DIR/$basename"
  echo "  Copied: $basename"
done

# Create individual posts for each mexico photo
for i in $(seq 1 10); do
  FILE="mexico-${i}.jpg"
  if [ -f "$PHOTOS_DIR/$FILE" ]; then
    cat > "$PHOTOS_COLLECTION/2020-01-08-mexico-${i}.md" << EOF
---
date: 2020-01-08
albums: [mexico]
photos:
  - file: "mexico-${i}.jpg"
    alt: "mexico-${i}"
---
EOF
    echo "  Created: _photos/2020-01-08-mexico-${i}.md"
  fi
done

# Update mexico album
cat > "_galleries/mexico.md" << EOF
---
layout: album
title: "Mexico"
slug: mexico
date: 2020-01-08
cover_photo: "mexico-1.jpg"
---
EOF
echo "  Updated: _galleries/mexico.md"

echo ""
echo "=== Migration complete ==="
echo "Created $(ls -1 $PHOTOS_COLLECTION/*.md 2>/dev/null | wc -l | xargs) photo posts"
echo "Don't forget to test with 'bundle exec jekyll serve'"
