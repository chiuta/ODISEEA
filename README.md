# ODISEEA

**English** · [Română](README.ro.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Español](README.es.md) · [Português](README.pt.md) · [Deutsch](README.de.md) · [Magyar](README.hu.md)

Version: 1.1 · Last updated: 2026-11-22

A ~4.5-minute documentary about **Voyager 1 and 2**, in a single HTML file that runs locally in the browser, with no server and no installation.

## Features

- Loads public NASA/JPL images (and Wikimedia Commons, public domain), with a “your own image” option for every scene.
- Procedural scenes generated on the GPU (WebGL): planets, probe, rocket, DSN antenna, the Golden Record, the heliosphere, Pale Blue Dot. The depth map comes from the geometry, so the 3D effect is correct.
- Export **2D**, **3D SBS half** (1920×1080) and **3D SBS full** (3840×1080), plus a “phone” mode for VR glasses such as VR BOX / 3DBOX.
- Ambient music generated in the browser; optional narration (live TTS, not recordable) or your own audio file.
- Fully translated into 8 languages: English, Română, Français, Italiano, Español, Português, Deutsch, Magyar (interface, narration, captions, credits). Choose the language from the selector at the top right.

## Usage

Open `ODISEEA.html` in Chrome (recommended), press “Load images” or go straight to “Play”. Keep the tab in the foreground while exporting.

## Known limitations

- NASA images only load if the browser has network access (CORS).
- Fractal textures are procedural, not photographic; the starfield added over real photos is artistic and can be switched off.
- The depth of real photos is estimated from brightness.
- Not tested on real glasses; the 3840×1080 export is heavy. An `.mp4` with vp9 may need conversion to H.264.
- The synthetic voice uses the browser's voices; if none exists for the chosen language, it stays off.

`fx.glsl` is the source of the fractal shader; it is already included in `ODISEEA.html`.

## Credits

Images: NASA/JPL-Caltech, as credited on each image (downloadable from the app). Check the credits before publishing.

Code licence: MIT.
