# Pixie Renderer Demo

Dieses Demo erweitert den sichtbaren Inhalt des unveraenderten
`tilemap_scroll_demo` um echte VIC-IV-Raster-Rewrite-Buffer-Pixies. Es besitzt
eine eigene Kopie der logischen 80x50-Welt und eigene doppelt gepufferte
RRB-Zeilen. Das native Demo wird weder gelinkt noch veraendert.

Jede Rasterzeile besteht aus:

```text
GOTOX + 41 Hintergrund-Tiles + dynamische Pixie-Laeufe + Zeilenende
```

Der 42 Eintraege grosse Tile-Praefix wird pro Buffer gecacht. In normalen
Frames werden nur sein Fine-Scroll-GOTOX sowie die dynamischen Pixie-Eintraege
erneuert. Eine vorcodierte 80x50-Map mit fertigen 16-Bit-Zeichencodes liegt ab
`$C800`. Beim Uebergang auf eine neue ganzzahlige Tileposition kopiert DMAgic
die 26 sichtbaren Zeilen direkt in den inaktiven RRB-Buffer. Dabei laufen
weder Divisionen noch Multiplikationen pro Tile und die statischen
Farbattribute werden nicht erneut geschrieben.

Einzelne animierte Tiles und Statistikziffern laufen ueber eine Dirty-Liste.
Sie patcht nur den betroffenen Eintrag in beiden Framebuffern sowie zwei Bytes
in der vorcodierten Map. Der Hintergrund kann daher niemals wegen zu vieler
Objekte ausfallen; bei voller Zeile werden nur Pixie-Slices verworfen.

`$D015` wird auf null gesetzt. Die Fallschirmspringer verwenden somit keinen
der acht Hardware-Sprites. Ihre vorbereiteten Y-Phasen ermoeglichen
pixelweiche Bewegung.

Die Statistik ist normaler Karteninhalt:

```text
01 02 03 ...
02 PIXIES 024 DROP 000
03
```

Steuerung:

- `Pfeiltasten`: Kamera pixelweise durch die 80x50-Map bewegen
- `Space`: WRAP / CLAMP umschalten
- `+` beziehungsweise `=`: vier Pixies hinzufuegen, maximal 128
- `-`: vier Pixies entfernen, mindestens einer

```sh
make build/pixie_renderer_demo.prg
make run PROGRAM=pixie_renderer_demo
```
