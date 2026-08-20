# Raster Rewrite Demo

Zwei physische VIC-IV-Sprite-Slots werden jeweils dreimal innerhalb desselben
Frames verwendet. Das ergibt sechs sichtbare Flugzeuge. Der geordnete Buffer
enthält sechs Ereignisse auf drei Rasterzeilen; Ereignisse derselben Zeile
werden gemeinsam in einem IRQ verarbeitet.

Die Ereignisfolge ist zyklisch: Rasterzeile 100 erzeugt die mittlere Reihe,
Zeile 190 die untere und Zeile 20 des folgenden Frames stellt die obere Reihe
wieder her und tauscht die Buffer. So bleibt zwischen den 16-Pixel-Sprites
ausreichend Sicherheitsabstand.

Die Ereignisse liegen in zwei Puffern. C beschreibt ausschließlich den
Backbuffer; der IRQ veröffentlicht ihn erst nach der letzten Restore-Gruppe.
Jeder Eintrag wählt Rasterzeile, Sprite-Slot und neue X/Y-Position. Der
Rasterhandler ist als cc65-`interruptor` registriert, prüft `$D019`, bestätigt
den IRQ und programmiert `$D012` für die nächste unterschiedliche Rasterzeile.

```sh
make
make run PROGRAM=raster_rewrite_demo
```
