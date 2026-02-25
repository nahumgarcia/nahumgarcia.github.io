#!/bin/bash
# Regenerates static pagination pages based on current content count.
# Run this after adding/removing posts or photos.
# Usage: ./script/update_pagination.sh

set -e

PER_PAGE=6

# Count items
POSTS=$(ls -1 _posts/*.md 2>/dev/null | wc -l | xargs)
PHOTOS=$(ls -1 _photos/*.md 2>/dev/null | wc -l | xargs)

# --- Home pagination (posts + photos) ---
HOME_TOTAL=$((POSTS + PHOTOS))
HOME_PAGES=$(( (HOME_TOTAL + PER_PAGE - 1) / PER_PAGE ))

# Remove old home pages
rm -rf page/

if [ "$HOME_PAGES" -gt 1 ]; then
  for i in $(seq 2 $HOME_PAGES); do
    mkdir -p "page/${i}"
    cat > "page/${i}/index.html" << EOF
---
layout: home_feed
title: "Página ${i}"
page_num: ${i}
per_page: ${PER_PAGE}
---
EOF
  done
  echo "Home: ${HOME_PAGES} pages (${HOME_TOTAL} items)"
else
  echo "Home: 1 page (${HOME_TOTAL} items), no pagination needed"
fi

# --- Photos pagination ---
PHOTO_PAGES=$(( (PHOTOS + PER_PAGE - 1) / PER_PAGE ))

# Remove old photo pages
rm -rf photos/page/

if [ "$PHOTO_PAGES" -gt 1 ]; then
  for i in $(seq 2 $PHOTO_PAGES); do
    mkdir -p "photos/page/${i}"
    cat > "photos/page/${i}/index.html" << EOF
---
layout: photo_page
title: "Fotos - Página ${i}"
page_num: ${i}
per_page: ${PER_PAGE}
---
EOF
  done
  echo "Photos: ${PHOTO_PAGES} pages (${PHOTOS} items)"
else
  echo "Photos: 1 page (${PHOTOS} items), no pagination needed"
fi
