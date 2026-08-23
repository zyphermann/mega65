# Pixie Renderer Demo

Erster echter VIC-IV-Raster-Rewrite-Buffer-POC. Er verwendet keine Hardware-
Sprites: anfangs 24 originale Fallschirmspringer (`$00-$03`) werden als transparente
NCM-Pixies ueber `GOTOX` in zeilenweise SEAM-Display-Listen geschrieben. Sie
fallen mit acht vorbereiteten Y-Pixelphasen weich nach unten. Darunter scrollt das originale
Crosshatch aus den tm6-Codes `$c7/$56/$ef/$83` in zwei unabhaengigen
Parallax-Ebenen: eine helle schnelle und eine dunklere halb so schnelle.

Steuerung:

- `Space`: Fallschirmmodus / geschlossene 1:2-Lissajous-Bahn
- `Pfeil hoch`: vier weitere Pixies (bis 128)
- `Pfeil runter`: vier Pixies weniger (mindestens einer)

Der Rahmenprofiler beginnt nach dem Bufferwechsel an Rasterzeile 0:

- Rot: Tastatur
- Gelb: Bewegung und Lissajous-Projektion
- Gruen: beide Hintergrundlisten
- Cyan: Pixie-Objektliste
- Magenta: HUD
- Orange: Auffuellen und Abschluss aller RRB-Zeilen
- Blau: freie CPU-Zeit bis zum naechsten Frame

Raster-Warten, DMA-Kopie und Pointerwechsel sind nicht Teil der Messfarben.

Die eigentliche Engine liegt wiederverwendbar unter
`shared/pixie_renderer/`. Das Demo pflegt nur ein Array aus `PixieObject`.
Position, Characterbasis, Frame-/Phasenabstand, Breite, Hoehe, Palette und
Sichtbarkeit eines Objekts reichen dem Renderer; Bewegungslogik gehoert nicht
zur Engine.

Jeder 16x16-Pixie belegt je nach Y-Phase zwei oder drei native
16x8-NCM-Zeichen. Pro Character-Zeile stehen 80 Eintraege bereit. Jede Hintergrundebene
benoetigt pro Zeile einen `GOTOX` und 21 native 16-Pixel-Zeichen. Zwei weitere Eintraege
sind unverhandelbar fuer den rechten Zeilenabschluss reserviert. Damit bleiben
34 Eintraege bzw. maximal 17 ueberlappende Pixie-Teile. `row_entries[]` und `dropped_last_frame` bilden
die erste explizite Kapazitaetskontrolle der spaeteren Engine.

Screen- und Colour-Display-Listen sind doppelt gepuffert. C baut immer in
normalem, unsichtbarem RAM. Bei Rasterzeile 0 kopiert DMAgic nur die 4.000
Colour-Bytes in die inaktive Colour-RAM-Seite; danach werden Screen- und
Colour-Pointer gemeinsam umgeschaltet. Der VIC liest daher niemals eine
Display-Liste, die der Renderer gerade veraendert.

```sh
make build/pixie_renderer_demo.prg
make run PROGRAM=pixie_renderer_demo
```
