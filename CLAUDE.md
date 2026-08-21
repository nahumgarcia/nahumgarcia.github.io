# Notas del sitio nahumgarcia.com

## Datos generales

- **URL:** https://nahumgarcia.com
- **Dominio:** Personalizado via archivo `CNAME` (`nahumgarcia.com`)
- **Hosting:** GitHub Pages (repo `nahumgarcia.github.io`)
- **Rama de deploy:** `gh-pages` — **todos los commits deben ir a esta rama**. Desde workspaces de Conductor, crear PR con `--base gh-pages` y mergear con `gh pr merge`.
- **Generador:** Jekyll (construido por GitHub Pages directamente)
- **Tema base:** [Textlog](https://github.com/heiswayi/textlog) v1.5.0 (autor: Heiswayi Nrird), muy personalizado
- **Plugins:** `jekyll-sitemap`
- **Markdown:** Kramdown con input GFM
- **Permalinks:** `pretty` (URLs sin `.html`)

## Estructura de archivos

```
├── _config.yml              # Configuración Jekyll
├── _layouts/
│   ├── default.html         # Layout base (head + nav + footer + footnote JS)
│   ├── page.html            # Páginas estáticas simples
│   ├── post.html            # Escritos/artículos (date, tags, TOC opcional, footnotes)
│   ├── home_feed.html       # Home: fila de fotos recientes + índice de escritos
│   ├── photo_post.html      # Post de foto individual (una foto + caption + lightbox)
│   ├── photo_page.html      # Índice de fotos (/fotos/), grid de miniaturas
│   └── tag_page.html        # Página de etiqueta
├── _includes/
│   ├── head.html            # Meta tags, CSS, og:image, twitter:image
│   ├── nav.html             # Nav: Sobre mí / Escritos / Fotos / RSS
│   ├── footer.html
│   ├── lightbox.html        # Lightbox JS vanilla (reutilizable)
│   └── disqus.html          # Comentarios Disqus (deshabilitado)
├── content/                 # collections_dir
│   ├── _posts/              # Escritos (2008–presente)
│   └── _photos/             # Posts de foto (una foto por post)
├── pages/                   # Páginas del sitio
│   ├── about.md
│   ├── posts.html           # /escritos/ — lista de posts con recuadros
│   ├── photos.html          # /fotos/ — grid de miniaturas de fotos
│   ├── categories.html
│   ├── tagged.html
│   └── 404.md
├── _sass/
│   ├── _base.scss           # Reset, tipografía, enlaces, código
│   ├── _layout.scss         # Todos los estilos de componentes
│   └── _syntax-highlighting.scss
├── css/main.scss            # Variables SCSS ($base-font-size: 18px, $max-width: 620px) e imports
├── assets/
│   ├── images/              # Imágenes de posts y og:image
│   └── photos/              # Fotos de photo posts (referenciadas en front matter)
├── index.html               # Home (usa layout: home_feed)
├── feed.xml                 # RSS
├── Gemfile
└── templates/post.md        # Plantilla para nuevos escritos
```

## Navegación

La nav (`_includes/nav.html`) muestra:
1. **Sobre mí** → `/about`
2. **Escritos** → `/escritos`
3. **Fotos** → `/fotos`
4. **RSS** → `/feed.xml`

## Colecciones

### `_posts` (escritos)
- Permalink: `/YYYY/MM/DD/:title/`
- Layout por defecto: `post`
- Front matter típico:
  ```yaml
  title: "Título"
  image: /assets/images/nombre.jpg  # para og:image
  author: Nahúm
  tags:
    - etiqueta
  toc: true  # opcional, activa tabla de contenidos
  ```

### `_photos` (posts de foto)
- Un post = una foto. Sin álbumes ni agrupaciones.
- Permalink: `/fotos/post/:name/`
- Layout por defecto: `photo_post`
- Front matter:
  ```yaml
  date: 2024-04-01
  title: "Título opcional"
  camera: "Cámara opcional"
  file: "foto.jpg"  # o ruta completa /assets/photos/foto.jpg si viene de Pages CMS
  ```
- El cuerpo (markdown bajo el `---`) es la descripción/caption, opcional.
- Las imágenes viven en `assets/photos/`.
- Si no se especifica `title`, Jekyll genera uno automáticamente a partir del nombre de archivo (p. ej. `granada-12.md` → "Granada 12").
- Las plantillas que renderizan `file` (`photo_post.html`, `photo_page.html`, `home_feed.html`) aceptan tanto el nombre de archivo suelto como la ruta completa con `/assets/photos/` por delante, para ser compatibles con el selector de imagen de Pages CMS.

## Home feed

El layout `home_feed.html` tiene dos bloques independientes:
- **Fotos:** fila de las fotos más recientes (`site.photos`), cuadradas, en una sola línea que se recorta al ancho de pantalla sin scroll. Clic abre el lightbox en la propia página. Solo se muestra en la página 1.
- **Escritos:** índice de `site.posts` — solo título, fecha y un resumen corto (el `subtitle` del post, o el cuerpo truncado si no tiene). Paginado vía `/page/N/`.

Cada bloque lleva una cabecera con enlace "Ver todo" a su listado completo (`/fotos/`, `/escritos/`).

## Escritos (`/escritos/`)

Muestra recuadros clicables con fecha, título, tags y tiempo de lectura. Cada recuadro es un `<a>` que lleva al artículo.

## Fotos (`/fotos/`)

Cuadrícula por filas y columnas (`.photo-grid`/`.photo-grid-item`, CSS Grid, sin recortar las fotos a un ratio fijo), con las fotos de cada fila centradas verticalmente entre sí. Todas las fotos, más recientes primero. Paginado vía `/fotos/page/N/` (generado por `_plugins/photo_pagination.rb`, 24 fotos por página).

Al hacer clic en una miniatura se abre el lightbox (no se navega) con la foto, título, fecha • cámara, descripción y un enlace "Ver publicación" al permalink individual. Las flechas del lightbox navegan entre todas las fotos cargadas en esa página. El `<a>` de cada miniatura mantiene un `href` real al permalink (el JS del lightbox intercepta el click normal con `preventDefault`), así que cmd/ctrl-click o "abrir en pestaña nueva" siguen llevando directamente al post individual.

## Estilos clave

- **Tipografía:** System font stack, peso base 300, bold = 700
- **Colores:** Variables CSS (`--text-color`, `--bg-color`, `--grey`, `--grey-dark`, `--grey-light`, `--hover-color`). Dark mode soportado.
- **Ancho texto:** `$max-width: 620px`
- **Ancho fotos/página:** hasta 1000px
- **Grid de `/fotos/`:** `.photo-grid`, CSS Grid con `align-items: center` (4 columnas desktop / 3 tablet / 1 móvil), fotos a su ratio natural, ocupa todo el ancho del navegador (se sale de `.site-outer` con el truco `100vw` + márgenes negativos)
- **Fotos sin bordes redondeados:** en toda la web (home, `/fotos/`, posts individuales, imágenes dentro de artículos)
- **Código:** Inconsolata/Monaco

## Funcionalidades

- **Lightbox:** JS vanilla, reutilizable via `{% include lightbox.html selector=".clase" photo_selector=".clase-foto" %}`. Lee de cada elemento `data-full`, `data-alt`, y opcionalmente `data-title`, `data-date`, `data-camera`, `data-desc` y `data-url` (enlace "Ver publicación"); si faltan estos últimos, esa parte del panel simplemente no se muestra. El panel de info va en dos columnas (título+fecha a la izquierda, cámara a la derecha) más la descripción debajo, el mismo layout que usa `photo_post.html` para el post individual.
- **Tabla de contenidos:** Opt-in con `toc: true` en front matter. Genera nav con h2/h3 del artículo.
- **Notas al pie:** Pastilla `•••` (no se muestra el número). Tooltip al hacer clic.
- **Open Graph:** `og:image` y `twitter:image` usando `image:` del front matter. Fallback al logo.
- **Clase `.fotos-duo`:** Para mostrar dos fotos verticales en columna side-by-side en un artículo.

## Tags en uso

`personal` · `madrid` · `música` · `tecnología` · `streaming` · `industria musical` · `podcasts` · `internet` · `perros` · `videojuegos` · `cine` · `diseño` · `fediverso` · `redes sociales` · `blogging` · `cocina`
