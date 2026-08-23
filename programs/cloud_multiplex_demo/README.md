# Cloud Multiplex Demo

Alle acht VIC-IV-Sprite-Slots zeigen zunächst je eine Time-Pilot-Wolke. Jeder
Slot wird nach seiner individuellen Unterkante plus zwölf Sicherheitszeilen
auf `(x+128, y+128)` umgeschrieben. Die acht Ereignisse werden nach Rasterzeile
sortiert. Das ergibt 16 sichtbare Wolkeninstanzen, ohne ein noch aktives Sprite
zu zerschneiden. Die 9-Bit-Rasterzeile 260 im unteren VBlank stellt die
Basissprites vor dem nächsten sichtbaren Frame wieder her und veröffentlicht
den Double-Buffer.

Beim Veröffentlichen wird die fertige Restore-Gruppe zusätzlich in die bereits
verbrauchte zweite Hälfte des aktiven Buffers kopiert. So werden die neuen
Basispositionen installiert, bevor derselbe neue Buffer für seine Rewrites
aktiv wird, ohne den Frontbuffer mitten in der IRQ-Gruppe umzuschalten.


Die sieben Wolkenslots verwenden originale 16×16-Sprites aus `tm4`/`tm5`
(erste Z80-Tabelle bei `$3176`). Sie bilden eine dreiteilige und zwei
zweiteilige Wolken entsprechend den Positionsroutinen `$2CBC/$3058`; nur die
achte, alleinstehende Originalwolke entfällt zugunsten des Spieler-Slots. Kein
Sprite wird skaliert. Die ersten Gruppen bewegen sich schneller und bilden so
die Vordergrundebene, die letzte Gruppe die langsamere Hintergrundebene.

Links und Rechts drehen einen unsichtbaren Flugvektor durch 32 Richtungen. Die
Wolken bewegen sich entgegengesetzt dazu. Beim vertikalen Überschreiten einer
128-Pixel-Grenze tauschen die beiden Kopien eines Slots ihre Rolle; der Buffer
wird danach anhand der neuen oberen Position erneut sortiert.

Mit `D` lässt sich eine Diagnoseanzeige ein- und ausschalten. Der Rasterhandler
wechselt dabei an jeder unterschiedlichen Rewrite-Zeile zwischen vier klar
unterscheidbaren Farbtönen. Die horizontalen Farbbänder markieren exakt die
Stellen, an denen Interrupts ausgeführt werden. Beim Ausschalten wird sofort
das normale Time-Pilot-Blau wiederhergestellt.

```sh
make run PROGRAM=cloud_multiplex_demo
```
