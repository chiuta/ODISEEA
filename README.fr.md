# ODISEEA

[English](README.md) · [Română](README.ro.md) · **Français** · [Italiano](README.it.md) · [Español](README.es.md) · [Português](README.pt.md) · [Deutsch](README.de.md) · [Magyar](README.hu.md)

Version : 1.1 · Dernière mise à jour : 15 novembre 2026

Documentaire d'environ 4,5 minutes sur **Voyager 1 et 2**, dans un seul fichier HTML qui s'exécute localement dans le navigateur, sans serveur ni installation.

## Fonctionnalités

- Charge des images publiques de la NASA/JPL (et de Wikimedia Commons, domaine public), avec l'option « votre image » pour chaque scène.
- Scènes générées de façon procédurale sur le GPU (WebGL) : planètes, sonde, fusée, antenne du DSN, Disque d'or, héliosphère, Pale Blue Dot. La carte de profondeur provient de la géométrie, l'effet 3D est donc correct.
- Export **2D**, **3D SBS moitié** (1920×1080) et **3D SBS complet** (3840×1080), ainsi qu'un mode « téléphone » pour lunettes VR de type VR BOX / 3DBOX.
- Musique d'ambiance générée dans le navigateur ; narration optionnelle (synthèse vocale en direct, non enregistrable) ou votre propre fichier audio.
- Entièrement traduit en 8 langues : English, Română, Français, Italiano, Español, Português, Deutsch, Magyar (interface, narration, sous-titres, crédits). Choisissez la langue avec le sélecteur en haut à droite.

## Utilisation

Ouvrez `ODISEEA.html` dans Chrome (recommandé), appuyez sur « Charger les images » ou directement sur « Lecture ». Gardez l'onglet au premier plan pendant l'export.

## Limites connues

- Les images de la NASA ne se chargent que si le navigateur a accès au réseau (CORS).
- Les textures fractales sont procédurales, non photographiques ; le fond d'étoiles ajouté aux photos réelles est artistique et peut être désactivé.
- La profondeur des photos réelles est estimée à partir de la luminosité.
- Non testé sur de vraies lunettes ; l'export 3840×1080 est lourd. Un `.mp4` en vp9 peut nécessiter une conversion en H.264.
- La voix de synthèse utilise les voix du navigateur ; s'il n'y en a pas pour la langue choisie, elle reste désactivée.

`fx.glsl` est la source du shader fractal ; il est déjà inclus dans `ODISEEA.html`.

## Crédits

Images : NASA/JPL-Caltech, selon le crédit de chaque image (téléchargeable depuis l'application). Vérifiez les crédits avant publication.

Licence du code : MIT.
