# ODISEEA

[English](README.md) · [Română](README.ro.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Español](README.es.md) · [Português](README.pt.md) · [Deutsch](README.de.md) · **Magyar**

Verzió: 1.1 · Utolsó frissítés: 2026. november 15.

Körülbelül 4,5 perces dokumentumfilm a **Voyager 1 és 2**-ről, egyetlen HTML-fájlban, amely helyben fut a böngészőben, szerver és telepítés nélkül.

## Funkciók

- Nyilvános NASA/JPL-képeket tölt be (és Wikimedia Commons-képeket, közkincs), minden jelenethez „saját kép” lehetőséggel.
- GPU-n (WebGL) procedurálisan generált jelenetek: bolygók, szonda, rakéta, DSN-antenna, Aranylemez, helioszféra, Pale Blue Dot. A mélységtérkép a geometriából származik, így a 3D hatás helyes.
- Exportálás **2D**, **3D SBS fél** (1920×1080) és **3D SBS teljes** (3840×1080) formában, valamint „telefon” mód VR BOX / 3DBOX típusú VR-szemüvegekhez.
- A böngészőben generált hangulatzene; opcionális narráció (élő hangszintézis, nem rögzíthető) vagy saját hangfájl.
- Teljesen lefordítva 8 nyelvre: English, Română, Français, Italiano, Español, Português, Deutsch, Magyar (felület, narráció, feliratok, közreműködők). A nyelvet a jobb felső sarokban választhatod ki.

## Használat

Nyisd meg az `ODISEEA.html` fájlt Chrome-ban (ajánlott), nyomd meg a „Képek betöltése” vagy közvetlenül a „Lejátszás” gombot. Exportáláskor tartsd előtérben a lapot.

## Ismert korlátok

- A NASA-képek csak akkor töltődnek be, ha a böngészőnek van hálózati hozzáférése (CORS).
- A fraktáltextúrák procedurálisak, nem fényképszerűek; a valódi fotókhoz adott csillagos háttér művészi, és kikapcsolható.
- A valódi fotók mélységét a fényességből becsüljük.
- Valódi szemüvegen nem tesztelt; a 3840×1080-as exportálás nehéz. A vp9-es `.mp4` H.264-re való átalakítást igényelhet.
- A szintetikus hang a böngésző hangjait használja; ha a kiválasztott nyelvhez nincs, kikapcsolva marad.

Az `fx.glsl` a fraktál shader forrása; már benne van az `ODISEEA.html` fájlban.

## Közreműködők

Képek: NASA/JPL-Caltech, az egyes képek megjelölése szerint (az alkalmazásból letölthető). Közzététel előtt ellenőrizd a forrásmegjelöléseket.

A kód licence: MIT.
