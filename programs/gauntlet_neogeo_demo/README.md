# Gauntlet Neo-Geo title demo

Dieses eigenständige MVS-Demo zeigt das konvertierte 320-x-224-Titelbild mit
20 vertikalen Line Sprites zu je 14 C-ROM-Tiles. Es benötigt keine global
installierte Cross-Toolchain: `build_rom.py` erzeugt den kleinen festen
68000-Programm-ROM direkt und prüft dabei Header, Größen und Assetstruktur.

```sh
make -C programs/gauntlet_neogeo_demo
make -C programs/gauntlet_neogeo_demo smoke
make -C programs/gauntlet_neogeo_demo run
```

Der erste Build lädt eine fest versionierte, per SHA-256 geprüfte
[ngdevkit](https://github.com/dciabrin/ngdevkit)-Bottle. Daraus werden nur der
bewährte `nullsound`-Treiber und `nullbios` verwendet. Es wird nichts global
installiert.

Die fertigen Cartridge-Dateien liegen in `build/rom/`:

| Datei | Zweck |
|---|---|
| `gaunttitle.zip` | Cartridge für MAME |
| `neogeo.xml` | lokale MAME-Softwareliste |
| `neogeo.zip` | quelloffenes nullbios für den Test |
| `gtdemo-p1.p1` | 68000-Programm, 1 MiB |
| `gtdemo-s1.s1` | transparentes FIX-ROM, 128 KiB |
| `gtdemo-m1.m1` | nullsound-Z80-ROM, 128 KiB |
| `gtdemo-v1.v1` | stilles Sample-ROM, 512 KiB |
| `gtdemo-c1.c1`, `gtdemo-c2.c2` | Sprite-Bitplanes, je 512 KiB |

Die ersten 256 C-ROM-Tiles bleiben transparent und für System-/Eye-Catcher-
Nutzung reserviert. Die 278 Titeltiles beginnen bei Tilecode 256. P1 lädt die
Neo-Geo-Paletten 16 bis 78, blendet FIX aus, löscht alle Line Sprites und setzt
20 unabhängige 16-Pixel-Spalten auf volle Größe.

`make smoke` prüft neben einem erfolgreichen Emulatorlauf drei 320-x-224-
Screenshots. Der Test verlangt, dass sich die Logo-Pixel nach sechs VBlanks
ändern und das Bild nach dem vollständigen 486-Frame-Zyklus wieder exakt dem
Ausgangsbild entspricht.
MAME 0.227 meldet beim
quelloffenen Ersatz-BIOS erwartungsgemäß `WRONG CHECKSUMS`, lädt es aber und
führt die Cartridge vollständig aus. Mit einem eigenen originalen
`neogeo.zip` kann die mitgelieferte Datei einfach ersetzt werden.

Der Schriftzug verwendet den vollständig aus dem laufenden Atari-ROM
rekonstruierten Zyklus. Er besitzt 20 unabhängig verlaufende Farbspuren und
162 eindeutige Phasen. Ein eigener VBlank-Handler schaltet alle drei VBlanks
weiter und schreibt ausschließlich die 91 tatsächlich belegten animierten
Palettenwörter; statische Bildfarben und C-ROM-Tiles bleiben unverändert.
Weil dieselbe logische Spur wegen der lokalen 16-Farben-Tiles in mehreren
Neo-Geo-Paletten vorkommt, aktualisiert die Routine alle Vorkommen synchron.
Ein kompletter Umlauf dauert wie beim Original 486 Frames beziehungsweise
8,1 Sekunden bei 60 Hz.
