# Notas del sitio nahumgarcia.com

## Datos generales

- **URL:** https://nahumgarcia.com
- **Dominio:** Personalizado via archivo `CNAME` (`nahumgarcia.com`)
- **Hosting:** GitHub Pages (repo `nahumgarcia.github.io`)
- **Rama de deploy:** `gh-pages`
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
│   ├── home_feed.html       # Feed principal: mezcla posts y fotos ordenados por fecha
│   ├── photo_post.html      # Post de foto individual (grid + caption + lightbox)
│   ├── photo_page.html      # Índice de fotos (/fotos/) con submenú
│   ├── album.html           # Álbum de fotos individual
│   └── tag_page.html        # Página de etiqueta
├── _includes/
│   ├── head.html            # Meta tags, CSS, og:image, twitter:image
│   ├── nav.html             # Nav: Sobre mí / Escritos / Fotos / RSS
│   ├── footer.html
│   ├── lightbox.html        # Lightbox JS vanilla (reutilizable)
│   └── disqus.html          # Comentarios Disqus (deshabilitado)
├── content/                 # collections_dir
│   ├── _posts/              # Escritos (2008–presente)
│   ├── _photos/             # Posts de foto
│   └── _photoalbums/        # Álbumes de fotos
├── pages/                   # Páginas del sitio
│   ├── about.md
│   ├── posts.html           # /escritos/ — lista de posts con recuadros
│   ├── photos.html          # /fotos/ — feed de fotos con submenú
│   ├── photos/
│   │   └── albums.html      # /fotos/albums/ — grid de álbumes
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
- Permalink: `/fotos/post/:name/`
- Layout por defecto: `photo_post`
- Front matter:
  ```yaml
  date: 2024-04-01
  title: "Título opcional"
  albums: [nombre-album]  # opcional
  tags:
    - etiqueta
  photos:
    - file: "foto.jpg"
      alt: "texto alt"
  ```
- Las imágenes viven en `assets/photos/`

### `_photoalbums` (álbumes)
- Permalink: `/fotos/album/:name/`
- Layout por defecto: `album`
- Front matter:
  ```yaml
  title: "Título del álbum"
  slug: nombre-album
  cover: "foto-portada.jpg"
  ```
- El álbum agrupa fotos de `_photos` que tengan `albums: [nombre-album]`

## Home feed

El layout `home_feed.html` mezcla `site.posts` y `site.photos` ordenados por fecha.
- Posts de texto: muestra meta (fecha • tiempo de lectura • tags), título y cuerpo (truncado si > 1500 palabras)
- Posts de foto: muestra meta (fecha • álbum • nº fotos), grid de fotos 3 columnas y caption opcional
- Paginación: `/page/N/` configurado en `_config.yml`

## Escritos (`/escritos/`)

Muestra recuadros clicables con fecha, título, tags y tiempo de lectura. Cada recuadro es un `<a>` que lleva al artículo.

## Fotos (`/fotos/`)

Submenú con dos secciones:
- **Publicaciones** → `/fotos/` — feed cronológico de photo posts
- **Álbumes** → `/fotos/albums/` — grid de álbumes

## Estilos clave

- **Tipografía:** System font stack, peso base 300, bold = 700
- **Colores:** Variables CSS (`--text-color`, `--bg-color`, `--grey`, `--grey-dark`, `--grey-light`, `--hover-color`). Dark mode soportado.
- **Ancho texto:** `$max-width: 620px`
- **Ancho fotos/página:** hasta 1000px
- **Grids de fotos:** 3 columnas desktop, 2 en móvil, gap 10px
- **Código:** Inconsolata/Monaco

## Funcionalidades

- **Lightbox:** JS vanilla, reutilizable via `{% include lightbox.html selector=".clase" photo_selector=".clase-foto" %}`
- **Tabla de contenidos:** Opt-in con `toc: true` en front matter. Genera nav con h2/h3 del artículo.
- **Notas al pie:** Pastilla `•••` (no se muestra el número). Tooltip al hacer clic.
- **Open Graph:** `og:image` y `twitter:image` usando `image:` del front matter. Fallback al logo.
- **Clase `.fotos-duo`:** Para mostrar dos fotos verticales en columna side-by-side en un artículo.

## Tags en uso

`personal` · `madrid` · `música` · `tecnología` · `streaming` · `industria musical` · `podcasts` · `internet` · `perros` · `videojuegos` · `cine` · `diseño` · `fediverso` · `redes sociales` · `blogging` · `cocina`
