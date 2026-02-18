#!/usr/bin/env bash
#
# Genera/actualiza el archivo .md de una galería a partir de las fotos en una carpeta.
#
# Uso: ./script/gallery.sh <carpeta> <título> [fecha]
# Ejemplo: ./script/gallery.sh mexico "Mexico" 2020-01-08
#
# - Escanea assets/photos/<carpeta>/ buscando imágenes (jpg, jpeg, png, webp)
# - Para cada imagen, busca un .md con el mismo nombre base para extraer descripción
# - Genera _galleries/<carpeta>.md con el front matter completo
# - Si el archivo ya existe, preserva title y date del existente (salvo que se pasen como argumentos)

set -euo pipefail

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PHOTOS_DIR="$SITE_DIR/assets/photos"
GALLERIES_DIR="$SITE_DIR/_galleries"

usage() {
  echo "Uso: $0 <carpeta> <título> [fecha]"
  echo "Ejemplo: $0 mexico \"Mexico\" 2020-01-08"
  exit 1
}

if [ $# -lt 2 ]; then
  usage
fi

FOLDER="$1"
TITLE="$2"
DATE="${3:-$(date +%Y-%m-%d)}"

PHOTO_PATH="$PHOTOS_DIR/$FOLDER"
GALLERY_FILE="$GALLERIES_DIR/$FOLDER.md"

# Verificar que la carpeta de fotos existe
if [ ! -d "$PHOTO_PATH" ]; then
  echo "Error: No existe la carpeta $PHOTO_PATH"
  exit 1
fi

# Si el archivo de galería ya existe, preservar title y date
if [ -f "$GALLERY_FILE" ]; then
  if [ $# -lt 3 ]; then
    EXISTING_DATE=$(sed -n 's/^date: *//p' "$GALLERY_FILE" | head -1)
    if [ -n "$EXISTING_DATE" ]; then
      DATE="$EXISTING_DATE"
    fi
  fi
  if [ $# -lt 2 ]; then
    EXISTING_TITLE=$(sed -n 's/^title: *"\(.*\)"/\1/p' "$GALLERY_FILE" | head -1)
    if [ -n "$EXISTING_TITLE" ]; then
      TITLE="$EXISTING_TITLE"
    fi
  fi
fi

# Buscar imágenes y ordenarlas naturalmente
IMAGES=()
while IFS= read -r -d '' file; do
  IMAGES+=("$(basename "$file")")
done < <(find "$PHOTO_PATH" -maxdepth 1 \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0 | sort -zV)

if [ ${#IMAGES[@]} -eq 0 ]; then
  echo "Error: No se encontraron imágenes en $PHOTO_PATH"
  exit 1
fi

# Generar el front matter
{
  echo "---"
  echo "layout: photo_set"
  echo "title: \"$TITLE\""
  echo "date: $DATE"
  echo "gallery: $FOLDER"
  echo "photos:"
  echo "  set: \"$FOLDER\""
  echo "  items:"

  for img in "${IMAGES[@]}"; do
    # Nombre base sin extensión
    base="${img%.*}"

    # Buscar archivo .md con descripción
    desc=""
    desc_file="$PHOTO_PATH/$base.md"
    if [ -f "$desc_file" ]; then
      desc=$(cat "$desc_file")
    fi

    echo "    - file: \"$img\""
    echo "      alt: \"$base\""
    if [ -n "$desc" ]; then
      echo "      description: \"$desc\""
    fi
  done

  echo "---"
} > "$GALLERY_FILE"

echo "Galería generada: $GALLERY_FILE (${#IMAGES[@]} fotos)"
