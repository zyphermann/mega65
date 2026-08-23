# Tilemap Scroll Demo

Eigenstaendiger POC fuer eine native VIC-IV-Tilemap. Die logische Map ist
80x50 Tiles gross, also exakt 2x2 sichtbare 40x25-Seiten. Im Speicher folgen
rechts 41 und unten 26 gespiegelte Tiles. Dadurch ist jeder gewrappte
Bildschirmausschnitt samt Fine-Scroll-Rand linear im Speicher vorhanden.

Pro Frame werden nur folgende VIC-IV-Werte geaendert:

- `SCRNPTR` und `COLPTR` fuer den ganzteiligen Tileversatz,
- `TEXTXPOS` und `TEXTYPOS` fuer den Pixelversatz von 0 bis 7.

Die Tilemap wird beim Scrollen weder kopiert noch als RRB-Liste neu erzeugt.
Das blinkende rote X zeigt Map-Aenderungen: Das logische Tile und seine bis zu
drei Spiegelkopien werden aktualisiert.

- `Pfeiltasten`: Kamera pixelweise durch die Map bewegen
- `Space`: WRAP / CLAMP umschalten
- Rot im Seitenrahmen: Registerwechsel am Frameanfang
- Orange im Seitenrahmen: Spiellogik und Scrollverwaltung

```sh
make build/tilemap_scroll_demo.prg
make run PROGRAM=tilemap_scroll_demo
```
