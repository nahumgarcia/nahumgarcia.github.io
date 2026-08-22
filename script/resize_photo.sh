#!/bin/bash
# Redimensiona fotos para nahumgarcia.com antes de subirlas por Pages CMS.
#
# Usa `sips` (nativo de macOS, sin dependencias) — pensado para poder
# invocarse desde una Shortcut de macOS/iOS con la acción "Ejecutar script
# de shell" (entrada del script: "como argumentos"). Ver notas de
# instalación como Shortcut más abajo.
#
# Uso:
#   ./script/resize_photo.sh foto1.jpg foto2.heic [...]
#
# Salida:
#   Copias redimensionadas en ~/Desktop/fotos-web (o en $RESIZE_OUTPUT_DIR
#   si se define). Los originales no se tocan. Los .heic/.heif se
#   convierten a .jpg (formato que espera el sitio).
#
# Por qué: las fotos del sitio se muestran como mucho a 1000px de ancho
# (`.photo-wall`, `.photo-post`, álbumes); 2000px de lado largo da margen
# de sobra para pantallas retina sin arrastrar el peso de los originales
# de cámara (algunos superan los 3000px y varios MB, lo que hace que el
# navegador tenga que decodificar bitmaps enormes en memoria aunque la
# foto se vea pequeña en pantalla — ver notas en CLAUDE.md).

set -euo pipefail

MAX_DIM=2000
JPEG_QUALITY=82
OUTPUT_DIR="${RESIZE_OUTPUT_DIR:-$HOME/Desktop/fotos-web}"

if [ "$#" -eq 0 ]; then
  echo "Uso: $0 <foto1> [foto2] [...]" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

for src in "$@"; do
  if [ ! -f "$src" ]; then
    echo "Aviso: no existe, se salta: $src" >&2
    continue
  fi

  name="$(basename "$src")"
  base="${name%.*}"
  ext="${name##*.}"

  case "$ext" in
    [Hh][Ee][Ii][Cc]|[Hh][Ee][Ii][Ff])
      dest="$OUTPUT_DIR/${base}.jpg"
      sips -s format jpeg "$src" --out "$dest" >/dev/null
      ;;
    [Jj][Pp][Gg]|[Jj][Pp][Ee][Gg]|[Pp][Nn][Gg])
      dest="$OUTPUT_DIR/$name"
      cp "$src" "$dest"
      ;;
    *)
      echo "Aviso: formato no soportado, se salta: $src" >&2
      continue
      ;;
  esac

  current_max=$(sips -g pixelWidth -g pixelHeight "$dest" \
    | awk '/pixelWidth|pixelHeight/ {print $2}' | sort -rn | head -1)

  if [ "$current_max" -gt "$MAX_DIM" ]; then
    sips -Z "$MAX_DIM" "$dest" >/dev/null
  fi

  case "$ext" in
    [Jj][Pp][Gg]|[Jj][Pp][Ee][Gg]|[Hh][Ee][Ii][Cc]|[Hh][Ee][Ii][Ff])
      sips -s formatOptions "$JPEG_QUALITY" "$dest" >/dev/null
      ;;
  esac

  echo "OK: $(basename "$dest")"
done

echo "Listo. Fotos en: $OUTPUT_DIR"
