# ODISEEA

[English](README.md) · [Română](README.ro.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Español](README.es.md) · [Português](README.pt.md) · **Deutsch** · [Magyar](README.hu.md)

Version: 1.1 · Letzte Aktualisierung: 15. November 2026

Dokumentation von etwa 4,5 Minuten über **Voyager 1 und 2**, in einer einzigen HTML-Datei, die lokal im Browser läuft – ohne Server und ohne Installation.

## Funktionen

- Lädt öffentliche NASA/JPL-Bilder (und Wikimedia Commons, gemeinfrei), mit der Option „dein Bild“ für jede Szene.
- Prozedural auf der GPU (WebGL) erzeugte Szenen: Planeten, Sonde, Rakete, DSN-Antenne, Goldene Schallplatte, Heliosphäre, Pale Blue Dot. Die Tiefenkarte stammt aus der Geometrie, der 3D-Effekt ist also korrekt.
- Export als **2D**, **3D SBS halb** (1920×1080) und **3D SBS voll** (3840×1080) sowie ein „Handy“-Modus für VR-Brillen wie VR BOX / 3DBOX.
- Im Browser erzeugte Ambient-Musik; optionaler Sprechertext (Live-Sprachsynthese, nicht aufnehmbar) oder eine eigene Audiodatei.
- Vollständig in 8 Sprachen übersetzt: English, Română, Français, Italiano, Español, Português, Deutsch, Magyar (Oberfläche, Sprechertext, Untertitel, Credits). Die Sprache wählst du oben rechts.

## Verwendung

Öffne `ODISEEA.html` in Chrome (empfohlen), drücke „Bilder laden“ oder direkt „Abspielen“. Lass den Tab beim Export im Vordergrund.

## Bekannte Einschränkungen

- NASA-Bilder laden nur, wenn der Browser Netzwerkzugriff hat (CORS).
- Fraktaltexturen sind prozedural, nicht fotografisch; der zu echten Fotos hinzugefügte Sternenhimmel ist künstlerisch und lässt sich abschalten.
- Die Tiefe echter Fotos wird aus der Helligkeit geschätzt.
- Nicht mit echten Brillen getestet; der Export in 3840×1080 ist aufwendig. Eine `.mp4` mit vp9 muss ggf. in H.264 umgewandelt werden.
- Die synthetische Stimme nutzt die Stimmen des Browsers; gibt es keine für die gewählte Sprache, bleibt sie aus.

`fx.glsl` ist der Quelltext des Fraktal-Shaders; er ist bereits in `ODISEEA.html` enthalten.

## Credits

Bilder: NASA/JPL-Caltech, gemäß dem Nachweis jedes Bildes (aus der App herunterladbar). Prüfe die Nachweise vor der Veröffentlichung.

Code-Lizenz: MIT.
