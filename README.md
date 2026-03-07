# nahumgarcia.com

Blog personal de Nahúm García. Comenzó como fork de [TextLog](https://github.com/heiswayi/textlog) pero ha evolucionado hasta ser un diseño propio.

[![LICENSE](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) ![GENERATOR](https://img.shields.io/badge/made_with-jekyll-blue.svg)

## Funcionalidades

### Contenido
- **Escritos** — artículos de blog con tags, tiempo de lectura y notas al pie con tooltip
- **Fotos** — posts de foto con grid de imágenes, caption y lightbox
- **Álbumes** — agrupaciones de fotos relacionadas
- **Feed principal** — mezcla cronológica de escritos y fotos en la home
- **Tabla de contenidos** — opt-in por post con `toc: true` en el front matter

### Diseño
- Tipografía system font, peso ligero (300), dark mode
- Grid de fotos de 3 columnas (2 en móvil)
- Recuadros clicables en la lista de escritos
- Pastilla `•••` para referencias de notas al pie (sin número visible)
- Clase `.fotos-duo` para dos fotos verticales en columna dentro de un artículo

### SEO y compartir
- Open Graph (`og:image`) y Twitter Cards con imagen del post
- RSS feed
- Permalinks limpios

## Estructura

```
content/
  _posts/          # Escritos
  _photos/         # Posts de foto
  _photoalbums/    # Álbumes
pages/             # Páginas estáticas
assets/
  images/          # Imágenes de posts
  photos/          # Fotos de photo posts
```

## Desarrollo local

Requiere Ruby (Homebrew, no system Ruby):

```bash
export PATH="/opt/homebrew/opt/ruby/bin:/usr/bin:$PATH"
bundle exec jekyll serve
```

## Licencia

[MIT](LICENSE.md)
