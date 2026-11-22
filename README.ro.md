# ODISEEA

[English](README.md) · **Română** · [Français](README.fr.md) · [Italiano](README.it.md) · [Español](README.es.md) · [Português](README.pt.md) · [Deutsch](README.de.md) · [Magyar](README.hu.md)

Versiune: 1.1 · Ultima actualizare: 2026-11-22

Documentar de ~4,5 minute despre **Voyager 1 și 2**, într-un singur fișier HTML care rulează local în browser, fără server și fără instalare.

## Funcții

- Încarcă imagini publice NASA/JPL (și Wikimedia Commons, domeniu public), cu opțiunea „imaginea ta” pentru fiecare scenă.
- Scene generate procedural pe GPU (WebGL): planete, sondă, rachetă, antenă DSN, Discul de Aur, heliosfera, Pale Blue Dot. Harta de adâncime vine din geometrie, deci efectul 3D e corect.
- Export **2D**, **3D SBS jumătate** (1920×1080) și **3D SBS complet** (3840×1080), plus modul „telefon” pentru ochelari VR de tip VR BOX / 3DBOX.
- Muzică ambientală generată în browser; narațiune opțională (TTS live, neînregistrabilă) sau fișier audio propriu.
- Tradusă complet în 8 limbi: English, Română, Français, Italiano, Español, Português, Deutsch, Magyar (interfață, narațiune, subtitrări, credite). Alegi limba din selectorul din dreapta sus.

## Utilizare

Deschide `ODISEEA.html` în Chrome (recomandat), apasă „Încarcă imaginile” sau direct „Redă”. Pentru export ține fila în prim-plan.

## Limite cunoscute

- Imaginile NASA se încarcă doar dacă browserul are acces la rețea (CORS).
- Texturile fractale sunt procedurale, nu fotografice; fundalul stelar peste pozele reale e artistic și se poate dezactiva.
- Adâncimea pozelor reale e estimată din luminozitate.
- Netestat pe ochelari reali; exportul 3840×1080 e greu. Un `.mp4` cu vp9 poate cere conversie la H.264.
- Vocea sintetică folosește vocile browserului; dacă nu există una pentru limba aleasă, rămâne oprită.

`fx.glsl` este sursa shader-ului fractal; e deja inclusă în `ODISEEA.html`.

## Credite

Imagini: NASA/JPL-Caltech, conform creditului fiecărei imagini (se descarcă din aplicație). Verifică creditele înainte de publicare.

Licență cod: MIT.
