# HUD Tilemap Demo

Das Demo zeigt alle 512 um 90 Grad gedrehten 8×8-Tiles aus `tm6` in ihrer
stabilen ROM-Reihenfolge. Die Pfeiltasten bewegen die Auswahl durch das
32×16-Raster. Das ausgewählte Feld wird schwarz markiert:

- Der linke sechsstellige Wert ist der dezimale Tilecode `0..511`.
- Rechts stehen zweistellige Rasterzeile und Rasterspalte.
- Eine zusätzliche Vorschau des ausgewählten Tiles erscheint darüber.
- `Q` beendet das Demo.

Damit lassen sich zusammengehörige 2×2-Gruppen eindeutig als vier Tilecodes
notieren, bevor daraus die Galerie der 16×16-Schiffsframes aufgebaut wird.
