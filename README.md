# MEGA65-Programme in C

Dieses Repository enthält mehrere eigenständige MEGA65-Programme. `make` baut
alle Programme, damit Änderungen an geteiltem Code sofort gegen alle Programme
geprüft werden.

```text
programs/<name>/   Quellcode und Makefile eines Programms
shared/            gemeinsam verwendete .c- und .h-Dateien
mk/program.mk      gemeinsame Build-Regeln
build/             erzeugte PRG-Dateien
```

## Voraussetzungen

Benötigt wird ein aktueller Entwicklungsstand von cc65, da die stabile Version
2.19 das MEGA65-Target noch nicht enthält.

Auf macOS mit Homebrew:

```sh
brew install cc65 --HEAD
```

Falls bereits eine ältere cc65-Version installiert ist:

```sh
brew reinstall cc65 --HEAD
```

## Bauen

```sh
make
```

Das erste Ergebnis liegt unter `build/hello_world.prg`. Neu bauen lassen sich
alle Programme mit:

```sh
make clean all
```

Ein neues Programm wird automatisch erkannt, sobald es ein eigenes Verzeichnis
mit `Makefile` unter `programs/` besitzt. Als Ausgangspunkt genügt:

```make
PROGRAM := mein_programm
SOURCES := main.c weitere_datei.c

include ../../mk/program.mk
```

Header aus `shared/` können direkt mit `#include "name.h"` eingebunden werden;
geteilte `.c`-Dateien werden automatisch mitgelinkt.

Die komplette indizierte 1024x1024-Tilemap wird einmal zentral nach
`shared/generated/time-pilot-tiles.png` konvertiert. Das gemeinsame Asset hat
die logische Auflösung 256x256, bewahrt Palette und Transparenz und steht allen
Demos zur Tile-Auswahl zur Verfügung.

## Tile-Demo

`programs/tile_demo` konvertiert beim Build das erste Flugzeug aus
`assets/time-pilot-v2.png` und zeigt es als 16x16-Full-Colour-Sprite an:

```sh
make
make run PROGRAM=tile_demo
```

Der Konverter `tools/png_tile.py` benötigt keine externen Python-Pakete. Über
`--tile-x` und `--tile-y` kann ein 16x16-Bereich ausgewählt werden. Die neue
1024x1024-Grafik ist indiziert und organisiert ihre Sprites in 64x64-Zellen.
Jeder 4x4-Quellpixelblock wird beim Import auf ein MEGA65-Pixel reduziert.

## Flug-Demo

Das dritte Testprogramm startet mit dem Bewegungsvektor `(1,0)`. Die linke und
rechte Pfeiltaste drehen Flugzeug und Vektor durch 32 Richtungen: vier
Hauptrichtungen und jeweils sieben Zwischenstufen. Die linke Hälfte stammt aus
dem PNG; unten und die rechte Hälfte werden durch Spiegelung erzeugt:

```sh
make run PROGRAM=flight_demo
```

Mit `Q` wird das Programm beendet.

Rahmen und Hintergrund verwenden das dunkle Blau aus `timepilot-screen.png`
(Referenz-RGB 0,0,100; VIC-IV-Darstellung 0,0,102). Die vertikale Bewegung nutzt den
natürlichen 8-Bit-Umlauf der VIC-Spritekoordinate (`255` nach `0` und zurück),
damit beim Wechsel zwischen Ober- und Unterkante kein Koordinatensprung entsteht.

Sieben Wolken bilden zwei Parallaxebenen: vier kleine Wolken bewegen sich
langsam, drei hardware-skalierte große Wolken schneller. Ihre Bewegung ist dem
Flugvektor entgegengesetzt. Beim horizontalen Verlassen werden Variante,
Abstand und Y-Position für den Wiedereintritt auf der Gegenseite verteilt.

## Timepilot-Demo

`timepilot` baut auf der Flug-Demo auf, hält das Flugzeug aber fest in der
Bildschirmmitte. Vier große Vordergrundwolken und drei kleine Hintergrundwolken
bewegen sich relativ zum gedrehten Flugvektor:

```sh
make run PROGRAM=timepilot
```

Links und Rechts werden als physischer Tastenzustand in jedem Frame gelesen.
Die feste Drehrate ist unabhängig von der Key-Repeat-Einstellung des Hostsystems.

## Raster-Rewrite-Demo

`raster_rewrite_demo` zeigt sechs Flugzeuge pro Frame, verwendet dafür aber nur
zwei VIC-IV-Sprite-Slots. Ein zyklisch geordneter Ereignispuffer schreibt beide Slots
auf drei Rasterebenen um. Ereignisse derselben Rasterzeile werden in einem IRQ
gruppiert; zwei Puffer werden ausschließlich nach der letzten Restore-Gruppe
getauscht:

```sh
make run PROGRAM=raster_rewrite_demo
```

Die oberen Instanzen bleiben fest, während die untersten beiden horizontal
gegeneinander pendeln. Mit `Q` wird das Programm beendet.

## Cloud-Multiplex-Demo

`cloud_multiplex_demo` verwendet alle acht Hardware-Sprite-Slots für 16
sichtbare Time-Pilot-Wolken. Jeder Slot wird im selben Frame ein zweites Mal
bei `(x+128, y+128)` dargestellt. Drei große Vordergrundwolken bewegen sich
schneller als die fünf kleinen Hintergrundwolken. Links und Rechts drehen den
simulierten Flugvektor durch 32 Richtungen:

```sh
make run PROGRAM=cloud_multiplex_demo
```

## Generischer Sprite-Multiplexer

`sprite_multiplexer_demo` füllt eine Liste mit logischen 16×16-Sprites und
erstellt daraus vor jedem Bild eine sortierte Raster-Rewrite-Liste für die acht
Hardware-Slots. Der IRQ sortiert nicht selbst, sondern arbeitet ausschließlich
den fertigen, doppelt gepufferten Plan ab. Das Stress-Demo bewegt 36
Time-Pilot-Wolkenformationen in drei Ebenen; zusammengesetzte Wolken erzeugen
insgesamt 72 logische Sprite-Komponenten. `D` zeigt die IRQ-Aktivität am Rahmen.

```sh
make run PROGRAM=sprite_multiplexer_demo
```

## Horizontaler Sprite-Multiplexer

`horizontal_sprite_multiplexer_demo` testet den VIC-IV-Sprite-Ringbuffer über
den Hardware-Tilemodus `SPRTILEN`. Ein einziger 16×16-Hardware-Sprite wird ab
seiner X-Position bis zum rechten Rand wiederholt. Links/Rechts verschiebt den
Startpunkt, `D` schaltet die Wiederholung zum direkten Vergleich ein und aus.
Freie CPU-Rewrites innerhalb einer Rasterzeile sind auf echter Hardware
möglich, werden von Xemu aber nicht cycle-genau dargestellt.

```sh
make run PROGRAM=horizontal_sprite_multiplexer_demo
```

## Tilemap-Scroll-Demo

`tilemap_scroll_demo` zeigt eine logische 80×50-Tilemap, also 2×2 sichtbare
40×25-Seiten. Gespiegelte Randbereiche machen jeden Wrap-Ausschnitt im
physischen VIC-Speicher zusammenhaengend. `SCRNPTR`/`COLPTR` waehlen den
ganzteiligen Ausschnitt und `TEXTXPOS`/`TEXTYPOS` den Pixelversatz. Beim
Scrollen werden weder die Map kopiert noch RRB-Listen erzeugt. Mit `Space`
wird zwischen Wrap und Clamp umgeschaltet.

```sh
make run PROGRAM=tilemap_scroll_demo
```

## Pixie-Renderer-Demo

`pixie_renderer_demo` verwendet dieselbe logische 80×50-Welt in eigenen
doppelt gepufferten RRB-Zeilen. Ein gecachter Praefix zeichnet 41
Hintergrund-Tiles; danach folgen echte `GOTOX`-/NCM-Pixies. Hardware-Sprites
bleiben abgeschaltet. Pfeiltasten scrollen, `Space` schaltet Wrap/Clamp und
`+`/`-` veraendern die Anzahl der Fallschirmspringer zwischen 1 und 128.

```sh
make run PROGRAM=pixie_renderer_demo
```

## In Xemu ausführen

1. Den aktuellen Xemu-Build für macOS von <https://github.lgb.hu/xemu/>
   herunterladen und den MEGA65-Emulator `xmega65` einrichten. Xemu benötigt
   beim ersten Start ein passendes MEGA65-ROM.
   Achtung: Die ebenfalls `xemu` genannte Xbox-Emulator-App ist ein anderes
   Projekt. Für den MEGA65 heißt das Programm typischerweise `xmega65` oder
   `xemu-xmega65`.
2. Xemu starten und im Menü **Run PRG directly** auswählen (alternativ die
   `.prg`-Datei auf das Xemu-Fenster ziehen und **Run/inject as PRG** wählen).
   Xemu lädt und startet das BASIC-PRG automatisch.

Über die Kommandozeile geht es ebenfalls:

```sh
xmega65 -prg build/hello_world.prg
```

Falls das Binary `xemu-xmega65` heißt:

```sh
make run XMEGA65=xemu-xmega65
```

Standardmäßig startet `make run` das Programm `hello_world`. Ein anderes
Programm lässt sich so auswählen:

```sh
make run PROGRAM=anderes_programm
```

Wenn automatisches Starten deaktiviert wurde, am BASIC-Prompt eingeben:

```text
RUN
```

Erwartete Ausgabe:

```text
HELLO WORLD FROM C ON THE MEGA65!
```

Alternativ kann das PRG auf ein Disk-Image oder eine SD-Karte kopiert und in
BASIC 65 geladen werden:

```text
DLOAD "HELLO.PRG"
RUN
```

## Warum `--target mega65`?

Das cc65-Target verwendet die MEGA65-Ladeadresse `$2001`, erzeugt den passenden
BASIC-Startheader und linkt gegen die MEGA65-Laufzeitbibliothek. Damit ist das
Ergebnis ein direkt ladbares `.prg` und kein Host-Executable.
