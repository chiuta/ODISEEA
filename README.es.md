# ODISEEA

[English](README.md) · [Română](README.ro.md) · [Français](README.fr.md) · [Italiano](README.it.md) · **Español** · [Português](README.pt.md) · [Deutsch](README.de.md) · [Magyar](README.hu.md)

Versión: 1.1 · Última actualización: 15 de noviembre de 2026

Documental de unos 4,5 minutos sobre **Voyager 1 y 2**, en un único archivo HTML que se ejecuta localmente en el navegador, sin servidor ni instalación.

## Funciones

- Carga imágenes públicas de la NASA/JPL (y de Wikimedia Commons, dominio público), con la opción «tu imagen» para cada escena.
- Escenas generadas de forma procedural en la GPU (WebGL): planetas, sonda, cohete, antena de la DSN, Disco de Oro, heliosfera, Pale Blue Dot. El mapa de profundidad procede de la geometría, por lo que el efecto 3D es correcto.
- Exportación **2D**, **3D SBS mitad** (1920×1080) y **3D SBS completo** (3840×1080), además de un modo «teléfono» para gafas VR tipo VR BOX / 3DBOX.
- Música ambiental generada en el navegador; narración opcional (síntesis de voz en directo, no grabable) o tu propio archivo de audio.
- Traducido por completo a 8 idiomas: English, Română, Français, Italiano, Español, Português, Deutsch, Magyar (interfaz, narración, subtítulos, créditos). Elige el idioma en el selector de la esquina superior derecha.

## Uso

Abre `ODISEEA.html` en Chrome (recomendado), pulsa «Cargar las imágenes» o directamente «Reproducir». Mantén la pestaña en primer plano durante la exportación.

## Limitaciones conocidas

- Las imágenes de la NASA solo se cargan si el navegador tiene acceso a la red (CORS).
- Las texturas fractales son procedurales, no fotográficas; el fondo estelar añadido a las fotos reales es artístico y se puede desactivar.
- La profundidad de las fotos reales se estima a partir del brillo.
- No probado con gafas reales; la exportación 3840×1080 es pesada. Un `.mp4` con vp9 puede requerir conversión a H.264.
- La voz sintética usa las voces del navegador; si no hay ninguna para el idioma elegido, queda desactivada.

`fx.glsl` es el código fuente del shader fractal; ya está incluido en `ODISEEA.html`.

## Créditos

Imágenes: NASA/JPL-Caltech, según el crédito de cada imagen (descargable desde la aplicación). Comprueba los créditos antes de publicar.

Licencia del código: MIT.
