# ODISEEA

[English](README.md) · [Română](README.ro.md) · [Français](README.fr.md) · **Italiano** · [Español](README.es.md) · [Português](README.pt.md) · [Deutsch](README.de.md) · [Magyar](README.hu.md)

Versione: 1.1 · Ultimo aggiornamento: 2026-11-22

Documentario di circa 4,5 minuti su **Voyager 1 e 2**, in un unico file HTML che funziona localmente nel browser, senza server e senza installazione.

## Funzioni

- Carica immagini pubbliche NASA/JPL (e Wikimedia Commons, pubblico dominio), con l'opzione «la tua immagine» per ogni scena.
- Scene generate proceduralmente sulla GPU (WebGL): pianeti, sonda, razzo, antenna DSN, Disco d'oro, eliosfera, Pale Blue Dot. La mappa di profondità deriva dalla geometria, quindi l'effetto 3D è corretto.
- Esportazione **2D**, **3D SBS metà** (1920×1080) e **3D SBS completo** (3840×1080), più una modalità «telefono» per occhiali VR tipo VR BOX / 3DBOX.
- Musica d'atmosfera generata nel browser; narrazione opzionale (sintesi vocale dal vivo, non registrabile) o un tuo file audio.
- Tradotto interamente in 8 lingue: English, Română, Français, Italiano, Español, Português, Deutsch, Magyar (interfaccia, narrazione, sottotitoli, crediti). Scegli la lingua dal selettore in alto a destra.

## Utilizzo

Apri `ODISEEA.html` in Chrome (consigliato), premi «Carica le immagini» o direttamente «Riproduci». Durante l'esportazione tieni la scheda in primo piano.

## Limiti noti

- Le immagini NASA si caricano solo se il browser ha accesso alla rete (CORS).
- Le texture frattali sono procedurali, non fotografiche; lo sfondo stellato aggiunto alle foto reali è artistico e si può disattivare.
- La profondità delle foto reali è stimata dalla luminosità.
- Non testato su occhiali reali; l'esportazione 3840×1080 è pesante. Un `.mp4` con vp9 può richiedere la conversione in H.264.
- La voce sintetica usa le voci del browser; se non ne esiste una per la lingua scelta, resta disattivata.

`fx.glsl` è il sorgente dello shader frattale; è già incluso in `ODISEEA.html`.

## Crediti

Immagini: NASA/JPL-Caltech, secondo il credito di ciascuna immagine (scaricabile dall'app). Verifica i crediti prima della pubblicazione.

Licenza del codice: MIT.
