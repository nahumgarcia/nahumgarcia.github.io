---
title: Automatizando la descarga de series con Hazel
author: Nahúm
 
tags:

categories:

---
  
Antes de nada, aclarar que esto es un pequeño apaño/ejercicio que me he hecho para automatizar el proceso de descarga, búsqueda de subtítulos y conversión/importación a iTunes para poder verlo después en el **Apple TV2** (o en el **iPad/iPhone** si quisiera). No tengo conocimientos de programación y he buscado la forma de hacerlo con mis propios medios, a la espera de que con los siglos, los rezos y las súplicas (y quizá alguna donación millonaria de @aloisiusblog), alguien saque algo que lo haga más rápido, limpio y mejor.

![](hazellogo.png)

Estas acciones de Hazel están pensadas para trabajar con un software que paramí, es el mejor para estas tareas porque permite manejarse parcial o totalmente mediante _scripts_ o comandos de terminal. Los programas que uso aparte de Hazel son <span class="s1">[iFlicks](http://www.iflicksapp.com/) / [mkmp4s](http://eduo.info/apps/mkmp4s)</span>, [SolEol](http://eduo.info/soleol-support/releases/SolEol-Mac.zip), <span class="s1">[TVShows 2](http://tvshowsapp.com/TVShows.zip) y por supuesto un software de descarga de torrent como [Transmission](http://www.transmissionbt.com/) (mi preferido)</span>. Aparte de Hazel, iFlicks también es un software de pago y para mí vale lo que cuesta. Es de los pocos conversores que permiten _passthrough_ de vídeo (junto con MP4Tools/MKVTools). Esto es, si tienes un AVI y lo quieres convertir para verlo en tu iPad, si el códec ya es .H264, sólo cambia el contenedor del vídeo por M4V, que es el que reconoce iTunes, y esto es un proceso que tarda segundos. Si ya tienes bajados subtítulos y con el nombre igual que el de vídeo (como debe ser), detecta el idioma y te los añade en el vídeo final (no los  "quema" en el vídeo, se pueden activar y desactivar en iTunes, Quicktime, VLC, etc, y puedes tener varios subtítulos a la vez). Además, busca los metadatos y las portadas estupendamente. 

Si quieres puedes usar **mkmp4s **en vez de iFlicks. mkmp4s está pensado para recodificar todo a un formato compatible con iTunes/iOS, pero también taggea, añade los subtítulos y añade a iTunes, usando para ello clientes de terminal de varios programas de código abierto. Lo bueno de usar mkmp4s es que ahora, el estándar de series de EZTV (con quien trabaja TVShows2) es MP4, un formato que ya es directamente compatible, de modo que no necesita recodificar y simplemente añade los subtítulos y los metadatos en cuestión de segundos. 

Otra ventaja de mkmp4s es que es gratis al igual que TVShows2 y que SolEol, ya que es todo Open Source, aunque al igual que los otros, mkmp4s es _donationware_, de modo que si te parece útil deberías considerar una donación a sus autores, (hazlo, aunque sea solo un poco a cada uno). 

Como desventajas, mkmp4s no permite passthrough de vídeo, por lo que todo lo que no sea MP4 lo recodificará, así que si te bajas todo en MKV, tardará entre unos 10 minutos (dependiendo de la máquina que tengas) en convertir un episodio de media hora a 720p. mkmp4s además, no notifica de lo que va haciendo, y no hay forma de saber si está trabajando más allá que la de mirar en Monitor de Sistema que HandbrakeCLI está activado y consumiendo recursos. **Esto lo he solucionado añadiendo una notificación de Growl en Hazel cada vez que procese algo**. Otra desventaja es que no descarga portadas para las series y tampoco pone los títulos de los episodios, aunque esto no es realmente importante. 

Ahora pasaré a explicar la configuración del flujo de Hazel dando por hecho que ya tienes instalado todo el software necesario, que tienes además de SolEol la carpeta adicional ‘SolEol Extras’ en _/Aplicaciones_, y que ya estás suscrito a series en TVShows. Si vas a usar mkmp4s, deberías copiar la carpeta con los contenidos del script a ~/Movies/. Puedes cambiar la ubicación si quieres pero entonces deberás poner la que hayas elegido en el bash script que lanza la acción _b) Procesar con mkmp4s y borrar_.

**1.- Configuración**

Primero crea la carpeta donde se van a procesar los vídeos. Yo la que he creado es _~/Películas/@Procesado_, pero tú puedes crearla donde quieras. Agrega esa carpeta a Hazel arrastrándola al recuadro “Folders”.

Después baja las acciones de Hazel de aquí: [http://db.tt/p9Ll9YOC](http://db.tt/p9Ll9YOC)<span class="s2">.</span>

<span class="s2">Verás que ahí hay **un** archivo de acciones, que deberás aplicar a la carpeta que hayas añadido a Hazel. Para ello, </span>selecciona la carpeta que has añadido antes a “Folders” y arrastra el archivo de acciones al recuadro “Rules” de la derecha. Todas las acciones se agregarán automáticamente, aunque tendrás que activarlas con el marcador que aparece desmarcado por defecto a la izquierda de cada acción. Verás que hay una acción para iFlicks (a) y otra para mkmp4s (b). De estas dos solo tienes que seleccionar una. 

Lo siguiente que debes hacer es editar el bash script embebido en laprimera acción “**Crea carpeta para cada película y busca subs**” y también el mismo que también aparece en “**Busca subs en carpetas viejas”,** sustituyendo _**USER**_ y _**PASSWORD**_ por tus datos de acceso a **[Opensubtitles.org](http://www.opensubtitles.org/)**. Si no estás registrado en Opensubtitles, es recomendable para usar SolEol aunque también puedes usarlo de forma anónima. En ese caso, simplemente quita esas dos opciones de la línea de comando de ambas copias del script.

![](hazelscript.png)

Además de eso, puedes especificar en qué idiomas busca los subtítulos. Yo tengo puesto inglés y español (_eng,spa_), pero puedes añadir otros. Para ello consulta la ayuda de SolEol_CLI y añade los parámetros que necesites.

Si vas a usar iFlicks, selecciona las opciones por defecto que va a utilizar cuando sea utilizado desde Hazel. Para ello, métete en las preferencias del programa, ve a la sección Quicktime y en la opción “Conversión de vídeo” selecciona “Compatible con iTunes”. Marca también la opción “Mover original a la papelera”. 

Con esto ya puedes decirle a TVShows que meta los nuevos capítulos descargados en esa carpeta de trabajo, como en la siguiente imagen.

![](tvshows.jpg)

Y ya está, en principio no hay que hacer nada más. En la carpeta verás que según TVShows añade capítulos y Hazel va trabajando, quedan carpetas en sin color, y otras en verde. Las verdes son las que tienen subtítulos y están siendo convertidas, después se borrarán automáticamente. Las que siguen sin color son las que aún no tienen subtítulos y Hazel seguirá buscando una vez al día hasta que encuentre o hasta que hagas algo con esos archivos.

Si usas iFlicks, éste dejará notificaciones de Growl según vaya conviertiendo episodios. mkmp4s en cambio, como decía antes, no notifica de forma nativa, ni hay forma de ver que está trabajando. Pero gracias a la opción de usar Growl en Hazel, según vaya procesando archivos verás las notificaciones correspondientes.

Ahora voy a explicar un poco cómo funciona. Si no te interesa conocer el proceso, pasa a las notas sobre iFlicks y mkp4s.

**2.- ¿Cómo funciona?**

Como comentaba antes, TVShows 2 descarga cada episodio nuevo en _@Procesado_. Allí se ejecuta la primera acción, que para cada archivo de vídeo nuevo que llega, crea una carpeta homónima, mete el archivo dentro de la carpeta y mediante el shell script llama a SolEol_CLI y busca subtítulos. Si no encuentra subtítulos no cambia el color de la carpeta. La siguiente acción se encarga de buscar subtítulos en esos episodios para los que no encuentra subtútulos, una vez al día nada más. En los vídeos para los que sí encontró subtítulos, el número de ítems en la carpeta aumentará a 2 ó más, de modo que la tercera acción marca esas carpetas de verde y permite que la cuarta acción inspeccione dentro de esas carpetas y envíe los archivos de vídeo y subtítulos a ser procesados por iFlicks o mkmp4s. Después, otra acción borra las carpetas de archivos que ya se han convertido.

**3.- Algunas notas sobre SolEol/Opensubtitles, iFlicks y mkmp4s**

Uno de los dos inconvenientes del sistema es que es que en contadas ocasiones no llega nunca a encontrar subtítulos. Hay que tener en cuenta además, que Opensubtitles (que es el único que tiene API) no tiene soporte oficial para series. Pero eso en sí no es problema del flujo de trabajo, es que no hay una solución definitiva aún para ese problema. Aún así tengo que decir que estos últimos meses usando este método apenas me ha pasado con series en emisión actual, así que no es demasiado problema. 

En iFlicks, en vez de seleccionar “iTunes Compatible” como formato por defecto, puedes especificar que convierta para un dispositivo específico, en cuyo caso no hará _passthrough_ y recodificará siempre a _.h264_ con los ajustes necesarios de resolución, canales de audio, etc.

Si os da por procesar con iFlicks archivos un poco viejos que ya tengáis descargados utilizando el modo “iTunes Compatible”, es probable que algunos os den error al intentar ser añadidos, y os diga que es porque iTunes está en modo _64bits_ (esto es una limitación conocida), así que a veces os tocará decirle que los vuelva a procesar, esta vez  cambiando el modo para que recodifique. El procedimiento para volver a ponerlos en cola de conversión es muy rápido, no hay que volver a añadirlos a iFlicks ni nada. En cada archivo de la cola que ha fallado hay una opción para devolverlo tal cual a la ventana principal, para especificar un nuevo modo de procesado. Como comentaba, esto no pasa generalmente con las descargas actuales que, de hecho, se mueven más hacia la compatibilidad total con iTunes y el entorno iOS.

mkmp4s convierte por defecto usando el preset “iPad” de Handbrake. Existen más opciones de conversión y podrías especificar otro formato en el script embebido en la acción Procesar con mkmp4s y borrar". Te recomiendo que eches un ojo a la [página del script](http://eduo.info/apps/mkmp4s) donde aparecen explicadas estas opciones.

De nuevo, recuerda que TVShows 2, SolEol y mkmp4s son **donationware**. Si te gustan, considera realizar una donación a sus desarrolladores, que se lo merecen. Para ello utiliza el botón de Paypal que aparece en las páginas de cada desarrollo. 

**4.- Bonus**

Aquí os dejo un vídeo donde se ve cómo trabajan Hazel e iFlicks cuando llega un vídeo a la carpeta. En dos minutos está el vídeo convertido con subtítulos sin hacer nada. En HD tarda un poco más, pero solo un poco. 

<iframe frameborder="0" height="360" src="http://www.youtube.com/embed/ivbcjYn7Zcw?rel=0" width="480"></iframe>

**Actualización 5 marzo 2012**: le he dado un repaso al proceso, ahora es enormemente más sencillo. Es necesario actualizar a Hazel 3 para que funcionen correctamente las nuevas acciones. Si quieres descargar en pdf la versión anterior del post para Hazel 2, haz click [aquí](http://g.virbcdn.com/_f/files/c7/FileItem-225421-SeriesHazel.pdf). Las acciones para Hazel 2 están [aquí](http://db.tt/6dDyJ1KZ). 

**Actualización 20 marzo 2012:** he añadido la opción de usar mkmp4s en vez de iFlicks. Explico ambos procedimientos y cada uno que elija el que más le conviene. 

**Actualización 23 de mayo de 2012:** ya han corregido el bug de iFlicks que impedía que añadiera subtítulos a los mp4\. He quitado las referencias a éste en el texto. Además he añadido notificaciones de Growl en los procesos con #mkmp4s.

