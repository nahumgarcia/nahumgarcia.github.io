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
│   ├── posts.html           # /escritos/ — temas + índice de todos los posts (estilo home)
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
- Sin subtítulo: el sitio no tiene ese campo (se eliminó de `_posts`, `post.html`, `posts.html` y `.pages.yml`).

### `_photos` (posts de foto)
- Un post = una foto. Sin álbumes ni agrupaciones.
- Permalink: `/fotos/post/:name/`
- Layout por defecto: `photo_post`
- Front matter:
  ```yaml
  date: 2024-04-01
  title: "Título"
  camera: "Cámara opcional"
  file: "foto.jpg"  # o ruta completa /assets/photos/foto.jpg si viene de Pages CMS
  ```
- `title` es obligatorio (tanto en `.pages.yml` como por convención en el contenido). Si un archivo no lo trae, Jekyll genera uno automáticamente a partir del nombre de archivo (p. ej. `granada-12.md` → "Granada 12") — esto es solo un fallback de Jekyll, no una alternativa válida al crear contenido nuevo.
- Un solo campo de fecha (`date`): es la fecha en la que se tomó la foto, no una fecha de publicación separada. Si solo se conoce el mes, se usa el día `01` como convención (p. ej. `2024-10-01`).
- El cuerpo (markdown bajo el `---`) es la descripción/caption, opcional.
- Las imágenes viven en `assets/photos/`.
- Las plantillas que renderizan `file` (`photo_post.html`, `photo_page.html`, `home_feed.html`) aceptan tanto el nombre de archivo suelto como la ruta completa con `/assets/photos/` por delante. Pero el valor guardado debe ser la **ruta completa**: la miniatura de Pages CMS (`Thumbnail`/`getRawUrl` en su código) resuelve `file` como ruta relativa a la raíz del repo en `raw.githubusercontent.com`, no relativa a `assets/photos/` — un nombre suelto como `"foto.jpg"` hace que la CMS busque el archivo en la raíz del repo y muestre el icono de imagen rota. Todo el contenido existente se migró a `/assets/photos/foto.jpg` por este motivo.

## Pages CMS

El sitio se edita también desde [Pages CMS](https://pagescms.org), configurado en `.pages.yml` (raíz del repo). Ese archivo define qué colecciones/campos ve el editor — **cualquier cambio en las colecciones, en su front matter o en cómo se generan los archivos (nombre de archivo, campos nuevos, `required`, etc.) debe reflejarse también en `.pages.yml`**, o Pages CMS se desincroniza con lo que realmente hay en `content/`.

- **`media`**: dos fuentes — `post-images` (`assets/images`, para el campo `image` de escritos) y `photo-assets` (`assets/photos`, para el campo `file` de fotos y portadas). Ambas con `output` en la misma ruta con `/` inicial que ya usa el sitio.
- **`content: posts`**: espeja `_posts` — título, fecha (opcional, no `required`: ver nota más abajo), imagen (selector con miniatura), autor, tags, toc, cuerpo. Sin campo de subtítulo (eliminado del sitio).
- **`content: photos`**: espeja `_photos` — fecha (opcional, es la fecha en que se tomó la foto), título (`required`, primera columna en la vista de tabla), cámara, foto (selector de imagen, `required`), descripción. `filename` fijado a `{year}-{month}-{day}-{fields.title}.md` para que no dependa del campo usado como `primary` en la vista.
- **`content: about`**: el único `type: file` — edita `pages/about.md`. Incluye `layout` y `permalink` como campos ocultos con `default`, porque Pages CMS reconstruye el front matter solo con los campos declarados en el esquema — cualquier clave del archivo que no esté en `.pages.yml` se pierde al guardar desde la CMS.
- El campo `date` de `posts` y `photos` **no es `required`** a propósito: se probó como obligatorio y provocó "Content validation failed: Required at date" al guardar desde la CMS (ver commit `0e0d320`). No se identificó la causa exacta del lado de Pages CMS, así que se optó por quitar la restricción en vez de perseguir un bug en código que no es de este repo.
- Antes de tocar `.pages.yml`, conviene validarlo contra el esquema real de Pages CMS (Zod), no solo por sintaxis YAML — así se detectaron varios errores durante el desarrollo. El repo de Pages CMS es público (`github.com/pages-cms/pages-cms`); su `lib/config-schema.ts` es la fuente de verdad.

## Home feed

El layout `home_feed.html` tiene dos bloques independientes, sin paginación (no hay `/page/N/`):
- **Fotos:** fila de las 6 fotos más recientes (`site.photos`), cuadradas, dentro del ancho del texto (`$max-width`, igual que Escritos — no a todo el ancho del navegador, a diferencia de `/fotos/`). Grid con columnas `1fr` (6 desktop / 4 tablet / 3 móvil) para que siempre quepan enteras sin recortar ninguna — el número de columnas visibles se ajusta ocultando las últimas `.home-photo-strip-item` por `nth-child` en vez de reducir su tamaño. Clic abre el lightbox en la propia página.
- **Escritos:** las 10 entradas más recientes de `site.posts` — solo título (peso regular, tamaño de texto base) y fecha, sin subtítulo/resumen ni líneas separadoras entre entradas. La fecha vive fuera del `<a>` (`.home-index-link` envuelve solo el título): no es parte del link, solo el título lo es.

Cada bloque usa como cabecera un `<h2>` cuyo texto ("Fotos"/"Escritos") es directamente el enlace a su listado completo (`/fotos/`, `/escritos/`) — no hay un "ver más" aparte.

## Escritos (`/escritos/`)

Sección "Temas" (pills de tags, enlazan a `/tagged/#tag`) seguida de un índice con **todos** los posts, con el mismo estilo simplificado que el bloque Escritos de la home (`.home-index`): solo título y fecha, sin tags, tiempo de lectura ni subtítulo.

La página de un tema individual (`/tagged/<tag>/`, `_layouts/tag_page.html`, generada por `_plugins/tag_pages.rb`) usa ese mismo `.home-index` para listar sus posts (título + fecha con `fecha.html`, ordenados por fecha descendente), en vez de su propio `.post-list` con fecha en `%Y-%m-%d`. El contador dice "N escritos sobre este tema" (no "entradas"). `.post-list` se mantiene para `pages/tagged.html` (índice de todos los tags) y `pages/categories.html`, que no se tocaron.

## Fotos (`/fotos/`)

Cuadrícula por filas y columnas (`.photo-grid`/`.photo-grid-item`, CSS Grid, sin recortar las fotos a un ratio fijo), con las fotos de cada fila centradas verticalmente entre sí. Todas las fotos, más recientes primero. Paginado vía `/fotos/page/N/` (generado por `_plugins/photo_pagination.rb`, 24 fotos por página).

Al hacer clic en una miniatura se abre el lightbox (no se navega) con la foto, título, fecha • cámara, descripción y un enlace "Ver publicación" al permalink individual. Las flechas del lightbox navegan entre todas las fotos cargadas en esa página. El `<a>` de cada miniatura mantiene un `href` real al permalink (el JS del lightbox intercepta el click normal con `preventDefault`), así que cmd/ctrl-click o "abrir en pestaña nueva" siguen llevando directamente al post individual.

## Estilos clave

- **Tipografía:** System font stack, peso base 300, bold = 700
- **Colores:** Variables CSS (`--text-color`, `--bg-color`, `--grey`, `--grey-dark`, `--grey-light`, `--hover-color`). Fondo blanco puro (`#fff`) en modo claro. Dark mode soportado.
- **`:hover` solo en dispositivos con hover real:** todas las reglas `:hover` del sitio (nav, footer, tags, TOC, lightbox, miniaturas, paginación, links de escritos/fotos en home y `/escritos/`, etc.) están envueltas en `@media (hover: hover)`. Sin esto, en táctil el navegador aplica el estado `:hover` al tocar y lo deja "pegado" hasta el siguiente toque en otro sitio, en vez de mostrar solo el estado normal. Al añadir un nuevo estilo `:hover`, envolverlo igual.
- **Subrayado en enlaces sin otra affordance visual:** `.toc a`, `.item-meta a`, `.lightbox-permalink`, `.home-section-header a`, `.home-index-link` y `.site-footer a` llevan subrayado permanente (desktop y móvil), con `text-decoration-color: var(--underline-color)` — un gris translúcido (`rgba(0,0,0,.25)` claro / `rgba(255,255,255,.3)` oscuro) para que no quede tan marcado como el texto. Pills, botones y paginación no lo necesitan porque ya tienen su propio look de "esto es interactivo". El nav (`.site-nav a`) tampoco lo lleva: son pocos links siempre visibles en la cabecera, no hace falta remarcarlos.
- **Selector de tema:** botón con solo dos iconos visibles (sol/luna), pero tres estados por detrás: automático (sigue `prefers-color-scheme`, sin `data-theme` ni `localStorage`), y claro/oscuro explícitos (`data-theme` + `localStorage`). Al pulsar, el botón alterna la apariencia actual; si el nuevo estado coincide con el del sistema, vuelve a automático en vez de fijar un `data-theme` explícito. Lógica en `_layouts/default.html`, iconos en `_includes/nav.html`.
- **Ancho texto:** `$max-width: 620px`
- **Ancho fotos/página:** hasta 1000px
- **Tamaño de texto uniforme:** `$base-font-size` (18px móvil / 20px desktop, definido en `body`) es el tamaño de referencia del texto "de cuerpo" en todo el sitio — los links del nav (`.site-nav a`) y del footer (`.site-footer a`) no fijan `font-size` propio, así que lo heredan directamente de `body`; `.home-index-title` (títulos de escritos en la home y en `/escritos/`) usa `font-size: inherit` por el mismo motivo, en vez de un valor fijo que se desincronizaba del salto a 20px en desktop.
- **Grid de `/fotos/`:** `.photo-grid`, CSS Grid con `grid-template-columns: repeat(auto-fill, minmax(170px, 1fr))` y `align-items: center` — el número de columnas se ajusta solo según el ancho disponible (nunca por debajo de ~170px por foto), fotos a su ratio natural, ocupa todo el ancho del navegador (se sale de `.site-outer` con el truco `100vw` + márgenes negativos) con `padding` propio a los lados (2rem desktop/tablet, 1.5rem móvil)
- **Fotos sin bordes redondeados:** en toda la web (home, `/fotos/`, posts individuales, imágenes dentro de artículos)
- **Código:** Inconsolata/Monaco

## Funcionalidades

- **Lightbox:** JS vanilla, reutilizable via `{% include lightbox.html selector=".clase" photo_selector=".clase-foto" %}`. Lee de cada elemento `data-full`, `data-alt`, y opcionalmente `data-title`, `data-date`, `data-camera`, `data-desc` y `data-url` (enlace "Ver publicación"); si faltan estos últimos, esa parte del panel simplemente no se muestra. El panel de info tiene el ancho del texto y está alineado a la izquierda: título y fecha en la misma línea (fecha a la derecha del título), cámara debajo en su propia línea, y descripción debajo de eso — el mismo layout que usa `photo_post.html` para el post individual. Cada `showLightbox()` usa un token incremental para descartar imágenes que tardan en cargar si el usuario ya avanzó a otra foto (evita que una carga lenta sobrescriba la foto actual), y el swipe táctil ignora los toques que empiezan sobre `.lightbox-controls` para no interferir con el tap en las flechas.
- **Tabla de contenidos:** Opt-in con `toc: true` en front matter. Genera nav con h2/h3 del artículo.
- **Notas al pie:** Pastilla `•••` (no se muestra el número). Tooltip al hacer clic.
- **Open Graph:** `og:image` y `twitter:image` usando `image:` del front matter. Fallback al logo.
- **Clase `.fotos-duo`:** Para mostrar dos fotos verticales en columna side-by-side en un artículo.

## Tags en uso

`personal` · `madrid` · `música` · `tecnología` · `streaming` · `industria musical` · `podcasts` · `internet` · `perros` · `videojuegos` · `cine` · `diseño` · `fediverso` · `redes sociales` · `blogging` · `cocina`
