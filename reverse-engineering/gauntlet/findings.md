# Atari Gauntlet: ROM-, Grafik- und Hardware-Befunde

Stand: 2026-08-23. Zielplattform ist ein echtes Neo Geo MVS-Modul für zwei
Spieler. Adressen und Bitnummern in diesem Dokument beziehen sich auf die
originale Atari-Hardware; alle
16-Bit-Werte der Haupt-CPU sind Big Endian.

Die Befunde wurden gegen den
[offiziellen MAME-Treiber](https://github.com/mamedev/mame/blob/master/src/mame/atari/gauntlet.cpp)
abgeglichen. Die Grafik- und Palettendateien wurden aus den lokalen ROMs bzw.
aus einem lokalen MAME-Lauf erzeugt. MAME ist dabei Referenz und Hilfsmittel,
nicht Bestandteil des späteren Ports.

## Kurzfassung

- Haupt-CPU: Motorola 68010 mit 7,1590905 MHz; Sound-CPU: 6502 mit
  1,7897726 MHz.
- Bild: 336 x 240 sichtbare Pixel, 59,922743 Hz, 456 x 262 Gesamtraster.
- Zwei 8-x-8-Grafikformate: 8192 gemeinsame 4-bpp-Tiles für Playfield und
  Motion Objects sowie 512 vorhandene 2-bpp-Alpha-/Zeichentiles.
- Playfield: 64 x 64 Tiles, spaltenweise im RAM; Alpha-Layer: 64 x 31,
  zeilenweise; Motion Objects: verkettete, variable Tile-Rechtecke.
- Die Farben stehen **nicht** in den drei PROMs. Sie werden als 1024
  IRGB4444-Wörter in Palette-RAM gehalten.
- Extraktion und erster Palette-Schnappschuss liegen unter `extracted/`.
- Die dokumentierte Zielarchitektur und erste Abbildung auf MVS stehen in
  [`target-neogeo-mvs.md`](target-neogeo-mvs.md).

## ROM-Satz

| Dateien | Zweck | Zusammenbau |
|---|---|---|
| `1307.9a`, `1308.9b`, `205.10a`, `206.10b`, `1409.7a`, `1410.7b` | 68010-Programm | gerade/ungerade Bytes interleaven; teilweise mit `ROM_CONTINUE` umgeordnet |
| `120.16r`, `119.16s` | 6502-Soundprogramm | `$4000-$7fff`, `$8000-$ffff` |
| `104.6p` | Alpha-Zeichen, 2 bpp | lokal 8 KiB = 512 Tiles |
| `111.1a` bis `118.2mn` | Playfield und Motion Objects, 4 bpp | in dieser Reihenfolge 256 KiB Grafikregion |
| `101.7u`, `102.5l`, `103.4r` | Motion-Object-Logik | Timing, Flip-Steuerung, Position/Größe; **keine Farb-PROMs** |

Alle lokalen Dateien stimmen per CRC/SHA-1 mit MAME überein, mit einer
erklärbaren Ausnahme: `136037-104.6p` ist lokal 8192 Bytes lang. MAME führt
eine 16384-Byte-Datei mit CRC `6c276a1d`; hängt man 8192 Nullbytes an die
lokale Datei an, entstehen exakt diese CRC und SHA-1
`ec383a8fdcb28efb86b7f6ba4a3306fea5a09d72`. Es fehlen somit keine
Zeichendaten.

Der Satz ist die englische Gauntlet-Revision mit Programm-ROMs `1307/1308`
und `1409/1410`; MAME nennt diesen Satz schlicht `gauntlet`.

## Asset-Build und extrahierte Grafik

Der lokale Makefile erzeugt Grafik, PNG-Übersichten und den Laufzeit-
Palettendump reproduzierbar:

```sh
make -C reverse-engineering/gauntlet
```

Ein reiner Grafiklauf benötigt nur Python und die lokalen ROMs:

```sh
make -C reverse-engineering/gauntlet graphics
```

`make palette-dump` startet MAME für 17 emulierte Sekunden und liest danach
die 1024 Palette-RAM-Wörter. `make help` listet alle Einzelziele. Der
Python-Extraktor benötigt keine externen Pakete. Er erzeugt:

| Datei | Inhalt |
|---|---|
| `extracted/chars.png` | Übersicht über 512 Alpha-Tiles |
| `extracted/chars.bin` | 512 Tiles, je 64 ungepackte Pen-Bytes |
| `extracted/playfield-motion-objects.png` | Übersicht über alle 8192 4-bpp-Tiles |
| `extracted/playfield-motion-objects.bin` | 8192 Tiles, je 64 ungepackte Pen-Bytes |
| `extracted/levels/level-001.txt` bis `level-114.txt` | normale Level als 32-x-32-ASCII-Karten |
| `extracted/levels/level-001.png` bis `level-114.png` | normale Level als 512-x-512-Tile-Renderings |
| `extracted/levels/demo-150.txt`, `demo-151.txt` | Karten des Demo-/Attract-Ablaufs |
| `extracted/levels/treasure-room-01.txt` bis `treasure-room-11.txt` | alle Treasure Rooms |
| `extracted/levels/index.txt` | Bank, ROM-Zeiger, Header und Packgröße aller 127 Karten |

Die Farben der PNGs sind bewusst eine Diagnosepalette: Ein Pixelwert entspricht
dem Pen-Index und nicht bereits einer Spielfarbe.

### Levelkarten und Kompression

`make levels` benötigt nur Python und die beiden Slapstic-ROMs `205.10a` und
`206.10b` für die Kartendaten; für die PNGs kommen die bereits extrahierten
Grafiktiles, die Laufzeitpalette und die Tabellen aus `1307/1308` hinzu. Es
schreibt 114 normale Karten, zwei Demo-Karten und elf Treasure Rooms, also je
127 ASCII- und PNG-Dateien. Jedes Zeichen der Textdateien liegt im
7-Bit-ASCII-Bereich.
Eine logische Zelle wird mit zwei Zeichen dargestellt: `..` ist freier Boden,
`##` ist Wand, alle noch nicht semantisch benannten Typen erscheinen
verlustfrei als zweistellige Hexzahl. Dadurch bleiben die Karten auch ohne
Spezialfont eindeutig und gut lesbar.

Jedes PNG ist 512 x 512 Pixel groß: 32 x 32 logische Zellen werden mit den
originalen 2-x-2-Atari-Tilekombinationen zu einer vollständigen 64-x-64-Karte
gerendert. Die erste Nachbarschaftsauswahl folgt der Routine bei `$4273a` und
den Tabellen ab `$a5c0`, `$b380` und `$b398`. Ein zweiter Pass bei
`$42b54/$42b92` baut normale und zerstörbare Wände aus einer
8-Nachbarn-Maske, der Formtabelle `$9c24` und den Wandtabellen ab `$a6c0` auf.
Damit werden nicht bloß Bodenquartette als Wände missdeutet. Das Spiel wählt
vier kosmetische Bodenvarianten per Zufallszahl; der Offline-Renderer ersetzt
dies durch einen reproduzierbaren Koordinaten-Hash. Playfield-Farben stammen
aus dem Palettendump und werden wie MAMEs
[`standard_irgb_decoder`](https://github.com/mamedev/mame/blob/master/src/emu/emupal.h#L133-L140)
als IRGB4444 dekodiert.

Die Typen `$03` und `$04` sind aufschließbare horizontale beziehungsweise
vertikale Wände. Sie sind keine Playfield-Tiles, sondern mehrteilige Motion
Objects. Der Renderer bildet dafür die Originalroutinen `$43f0c` und `$44080`
nach: Anschlusswände bis zwei Zellen Entfernung wählen über die Tabellen
`$a040-$a0aa` Spritecode, Versatz und Objektgröße. Die Pixel verwenden die
echte Motion-Object-Palettengruppe 0 und Pen 0 bleibt transparent. Vertikale
Objekte sind an ihrer Unterkante verankert: 24 beziehungsweise 32 Pixel hohe
Formen ragen daher über ihre 16-Pixel-Zelle nach oben. Der Solid-Test `$426c8`
erkennt dabei ausschließlich die als Code `$8000` angelegten Playfield-Wände;
die blauen Türsegmente selbst gelten für diese Auswahl als offen. Aus den drei
Zuständen je Ende entstehen neun Formen: freies Ende, gerade Wandmündung und
zurückgesetzte Wandmündung, jeweils in beiden Richtungen kombiniert. Die
transparenten Pixel der längeren Anschlussobjekte lassen die orange/braune
Playfield-Endkappe stehen und erzeugen gemeinsam mit ihr die sichtbare
Mündung.

Die Typen `$09-$0b` bilden die drei Stufen der Knochen-Generatoren, aus denen
Geister entstehen; `$0c-$17` sind die Blockvarianten der übrigen
Gegnergeneratoren. Der generische Objektloader bei `$441f6`
baut sie gemäß `$c534/$c5ac/$c624/$c660` als mehrteilige Motion Objects auf.
Je nach Variante sind sie 3 x 2 oder 3 x 3 Tiles groß, wählen ihre
Palettengruppe ebenfalls aus `$c660` und ragen absichtlich über ihre
16-x-16-Levelzelle hinaus. Der Offline-Renderer bewahrt diese Überlappung und
zeichnet sie auf der separaten Motion-Object-Ebene.

Auch die Typen `$19-$27` benutzen vollständige 3-x-3-Motion-Objects. Dazu
gehören die weißen Monster-/Knochenobjekte, die bei einer Darstellung nur des
ersten 8-x-8-Tiles verschwinden oder wie Diagnoseartefakte wirken würden.

Motion-Object-Pen 1 ist bei dieser Hardware keine normale Farbe. Nach den
Gauntlet-Schaltplänen und MAMEs `screen_update` löscht er Playfield-Farbbit
`$80`. Der PNG-Renderer hält deshalb für jedes Hintergrundpixel auch die
entsprechende Farbe aus den Playfield-Gruppen 16-23 bereit. Besonders die
Knochen-Generatorgrafik benötigt diesen Sonderfall.

Die Itemgruppe `$28-$35` wird nun nach denselben Objekttabellen vollständig
gerendert. In Level 1 kommen insbesondere Schatztruhen (`$28`), Nahrung
(`$2b`) und Schlüssel (`$35`) vor. Für Nahrung wählt der Originalcode eines
von drei Bildern aus `$cbe2`; der Offline-Renderer trifft diese Wahl mit einem
reproduzierbaren Koordinaten-Hash.

Andere Nicht-null-Objektzellen, die nicht bereits spezielle Playfield-Zellen
sind, erhalten weiterhin ein helles Diagnose-Overlay aus ihrem initialen
Motion-Object-Code der Tabelle `$c534`. Das bewahrt Items, Generatoren und
Gegnerpositionen in der Übersicht. Es ist ausdrücklich kein eingefrorener
Gameplay-Frame: Animation, offene Türen und zerstörte Wände entstehen erst
durch weitere Spielroutinen.

Die Dateien sind nicht aus dem sichtbaren Atari-Tilemap zurückgerechnet. Der
Extraktor bildet direkt den originalen 68010-Leveldecoder bei `$4ad06` nach:

- Das geschützte ROM ergibt nach Even/Odd-Interleave vier 8-KiB-Bänke im
  CPU-Fenster `$038000-$039fff`.
- Bank 0 enthält ab dem Long-Zeiger bei `$038000` die Level-Zeigertabelle.
- Bank 3 enthält ab Offset `$1fd4` gepackte 2-Bit-Banknummern, vier Einträge je
  Byte. Die Banknummern entsprechen den vier physischen ROM-Bänken.
- Normale Definitionen benutzen die internen IDs 0-113. IDs 150-151 gehören
  zum Demo-/Attract-Ablauf; IDs 152-162 sind elf Treasure Rooms. IDs 114-149
  besitzen in dieser Revision keinen Levelzeiger.
- Ein Record beginnt mit einem 14-Byte-Header. Die vier Bytes an Offset
  `+10..+13` sind das kleine Typwörterbuch des Kompressors; der Befehlsstrom
  beginnt bei `+14`.
- Der Decoder erzeugt 1024 logische Typzellen. Er beginnt bei Index 32 und
  beherrscht Literaltypen, Wiederholungen des aktuellen Typs, Leer-/Wandläufe
  sowie vertikale Rückwärtsläufe in Schritten von 32 Zellen.
- Die reservierte erste Zeile füllt der Loader bei `$42684` zunächst mit Typ
  `$01`. Die spätere Objektinitialisierung kann einzelne Durchgänge wieder
  öffnen und Loader-Marker entfernen. Die Textdateien zeigen den
  deterministischen Decoderstand plus diese obere Randzeile und bewahren Typ
  `$05` sichtbar als Loader-Marker.

Das logische Raster ist zeilenweise 32 x 32 organisiert. Eine Zelle wird im
Atari-Renderer zu einem 2-x-2-Block aus 8-x-8-Tiles und entspricht damit einer
16-x-16-Weltzelle. Genau dieses Raster ist die geeignete Ausgangsform für den
Neo-Geo-Port. Dateinummer `001` entspricht ROM-ID 0, Dateinummer `114` der
ROM-ID 113; die separat geführte Bildschirm-Levelnummer kann im endlosen
Spielablauf davon abweichen.

### Alpha-/Zeichenformat

- 8 x 8 Pixel, 2 bpp, 16 ROM-Bytes pro Tile.
- Die MAME-Planeoffsets 0 und 4 entsprechen innerhalb eines ROM-Bytes den
  physischen Bits 7 und 3. Die linke Pixelhälfte liegt im ersten, die rechte im
  zweiten Byte einer Zeile; gelesen wird jeweils MSB nach LSB.
- Y-Schritt ist 16 Bit.
- Das lokale 8-KiB-ROM enthält damit 512 Tiles. Der 10-Bit-Tileindex im
  Alpha-RAM könnte 1024 adressieren, die obere Hälfte ist bei diesem Satz leer.

### Playfield-/Motion-Object-Format

- 8 x 8 Pixel, 4 bpp planar, 32 ROM-Bytes pro Tile.
- Die zusammengefügte 256-KiB-Region besteht aus vier 64-KiB-Plane-Blöcken.
- 8 Bytes je Plane und Tile, ein Byte je Zeile; die ROM-Bits werden invertiert
  und innerhalb jeder Zeile MSB nach LSB gelesen.
- Ergebnis: 8192 Tiles. Playfield und Motion Objects benutzen dieselben Daten.
- Hardware und MAME XORen den sichtbaren Tilecode zusätzlich mit `$0800`.

## Paletten

Palette-RAM liegt bei `$910000-$9107ff` und enthält 1024 16-Bit-Wörter:

```text
Bit 15..12  Intensität
Bit 11..8   Rot
Bit  7..4   Grün
Bit  3..0   Blau
```

Die vier Bänke sind:

| Adresse | Indizes | Zweck |
|---|---:|---|
| `$910000-$9101ff` | 0-255 | Alpha-Layer |
| `$910200-$9103ff` | 256-511 | Motion Objects |
| `$910400-$9105ff` | 512-767 | Playfield |
| `$910600-$9107ff` | 768-1023 | Reserve/extra |

`extracted/palette.bin` ist ein 2048-Byte-Schnappschuss etwa 15 Sekunden nach
Reset im Titel-/Attract-Ablauf. `extracted/palette.csv` zerlegt jedes Wort in
Bank, Intensität und RGB-Nibbles. Zu diesem Zeitpunkt sind 41 Alpha-, 211
Motion-Object- und 231 Playfield-Einträge ungleich null; die Extra-Bank ist
leer. Weil das Programm die Palette dynamisch ändern kann, ist dies eine
Momentaufnahme, keine Garantie für alle Level und Effekte.

Reproduzierbarer Dump mit MAME:

1. ROMs unter einem MAME-ROM-Pfad als Satz `gauntlet` bereitstellen.
2. Die lokale `104.6p`-Datei für MAME auf 16384 Bytes mit Nullbytes auffüllen.
3. Im Projektwurzelverzeichnis starten:

```sh
mame gauntlet -rompath ROMPFAD -skip_gameinfo -video none -sound none \
  -autoboot_script tools/dump_gauntlet_palette.lua -seconds_to_run 17
python3 tools/extract_gauntlet_graphics.py --palette-dump gauntlet-palette.bin
```

## Haupt-CPU: Speicherlayout

Der 68010 arbeitet mit 24-Bit-Adressen. Große Bereiche besitzen Hardware-
Mirrors; für den Port sollten wir zunächst nur die unten genannten
Basisadressen nachbilden.

| Adresse | Größe | Funktion |
|---|---:|---|
| `$000000-$037fff` | 224 KiB | Programm-ROM |
| `$038000-$039fff` | 8 KiB Fenster | Atari Slapstic 104, bankgeschützter ROM-Bereich |
| `$040000-$07ffff` | 256 KiB | Programm-ROM-Bereich |
| `$800000-$801fff` | 8 KiB | Work RAM |
| `$802000-$8023ff` | 1 KiB Adressraum | 2804 EEPROM, nur unteres Byte |
| `$803000-$80300f` | — | Eingänge, Status, Soundantwort |
| `$803100-$803171` | — | Watchdog, Latches, IRQ-ACK, EEPROM/Sound-Steuerung |
| `$900000-$901fff` | 8 KiB | Playfield-RAM, 4096 Wörter |
| `$902000-$903fff` | 8 KiB | Motion-Object-RAM, 1024 Objekte x 4 Wörter (split) |
| `$904000-$904fff` | 4 KiB | freies Video-RAM |
| `$905000-$905f7f` | 3968 B | Alpha-RAM, 64 x 31 Wörter |
| `$905f6e-$905f6f` | 1 Wort | Y-Scroll und Playfield-Tilebank; überlappt Alpha-Bereich |
| `$905f80-$905fff` | 128 B | SLIP-Tabelle für Motion Objects |
| `$910000-$9107ff` | 2 KiB | Palette-RAM |
| `$930000-$930001` | 1 Wort | X-Scroll |

VBLANK erzeugt IRQ 4; Schreiben nach `$803140` quittiert ihn. Eine Antwort der
Sound-CPU erzeugt IRQ 6. Der Watchdog löst nach acht nicht bedienten VBLANKs
aus.

## Video-RAM-Wortformate

### Playfield `$900000`

```text
15       X-Flip
14..12   Palette 0..7
11..0    Tileindex; effektiver Code = (Tilebank * $1000 + Index) XOR $0800
```

Das Tilemap ist 64 x 64 und **spaltenweise** gespeichert. Die effektive
Farbgruppe ist bei Gauntlet `24 + Palette`; jede Gruppe umfasst 16 Pens.

### Alpha `$905000`

```text
15       opaque (sonst Pen 0 transparent)
14..10   Palette/Farbgruppe
9..0     Tileindex
```

Genauer Farbcode laut Hardwaremodell:
`((word >> 10) & $0f) | ((word >> 9) & $20)`. Die vier unteren Gruppenbits
kommen aus Wortbits 13-10, Wortbit 14 wird Gruppenbit 5; Gruppenbit 4 bleibt
null. Damit sind 32 Gruppen über die Hardwareindizes 0-15 und 32-47
erreichbar. Wortbit 15 steuert ausschließlich `opaque`. Das Alpha-Tilemap ist
64 x 31 und zeilenweise gespeichert; jede Farbgruppe hat 4 Pens.

### Motion Objects `$902000`

Die 1024 Einträge bestehen logisch aus vier getrennten Worttabellen:

```text
word[object +    0]  Bits 14..0  Tilecode
word[object + 1024]  Bits 15..7  X; Bits 3..0 Palette
word[object + 2048]  Bits 15..7  Y; Bit 6 X-Flip;
                     Bits 5..3 Breite-1; Bits 2..0 Höhe-1
word[object + 3072]  Bits  9..0  Link zum nächsten Objekt
```

Es gibt kein Y-Flip-Bit. Pen 0 ist transparent. Die Hardware verfolgt eine
verkettete Liste, deren Start pro 8 Rasterzeilen aus der SLIP-Tabelle kommt.
Ein MO mit Pen 1 besitzt Sonderlogik: Statt normal gezeichnet zu werden,
invertiert es Playfield-Farbbit `$80` (laut MAME anhand der Schaltung geprüft).

## Vom Levelraster zum fertigen Pixel

### Drei verschiedene Raster

Gauntlet benutzt gleichzeitig drei Raster, die nicht verwechselt werden
dürfen:

| Ebene | Raster | Einheit | Ablage |
|---|---:|---:|---|
| Leveldefinition | 32 x 32 | 16 x 16 Pixel | logisch zeilenweise |
| Playfield | 64 x 64 | 8 x 8 Pixel | im RAM spaltenweise |
| Motion Objects | bis 1024 Einträge | Rechtecke aus 8-x-8-Tiles | vier getrennte Worttabellen plus Links |

Eine logische Levelzelle `(x,y)` belegt im Playfield vier Tiles:

```text
Levelzelle (x,y), 16 x 16 Pixel

        Spalte 2x       Spalte 2x+1
       +---------------+---------------+
2y     | Tile 0: TL    | Tile 1: TR    |
       +---------------+---------------+
2y+1   | Tile 2: BL    | Tile 3: BR    |
       +---------------+---------------+
```

Bei `TILEMAP_SCAN_COLS` lautet der Playfield-Wortindex für ein 8-x-8-Tile
`tile_x * 64 + tile_y`. Damit liegen die vier Wörter einer Levelzelle an:

```text
TL = (2*x    ) * 64 + (2*y    )
TR = (2*x + 1) * 64 + (2*y    ) = TL + $40 Wörter
BL = (2*x    ) * 64 + (2*y + 1) = TL + 1
BR = (2*x + 1) * 64 + (2*y + 1) = TL + $41 Wörter
```

Das erklärt die im 68010-Code sichtbaren Byteabstände `$80`, `$02` und
`$82`. Der Offline-Renderer gibt dieselben vier Wörter in der anschaulicheren
Reihenfolge TL, TR, BL, BR direkt in das 512-x-512-PNG aus.

### Playfield-Aufbau in zwei Durchgängen

Der erste Durchgang (`$4273a`) setzt Boden und Sonderboden. Vier kosmetische
Bodenvarianten werden im Spiel zufällig gewählt; nur diese Wahl ersetzt der
Offline-Renderer durch einen stabilen Koordinaten-Hash. Die eigentlichen
Wände entstehen anschließend in einem zweiten Durchgang:

1. `$441f6` legt für eine feste Playfield-Wand im zugehörigen MO-RAM-Slot den
   internen Belegungscode `$8000` ab. Dieser Eintrag ist hier vor allem eine
   Kollisions-/Nachbarschaftsmarke, nicht die sichtbare orange Wandgrafik.
2. `$42b54` läuft über die 32-x-32-Slots und ruft für jeden `$8000`-Eintrag
   `$42b92` auf.
3. `$42c9c` fragt die acht Nachbarn über `$426c8` ab und baut diese Maske:

```text
Bit 0  links-oben       Bit 1  oben       Bit 2  rechts-oben
Bit 3  links                                   Bit 4  rechts
Bit 5  links-unten      Bit 6  unten      Bit 7  rechts-unten
```

4. Das Maskenbyte wählt über `$9c24` eine Wandform. Wandthema und Form wählen
   anschließend vier Tilewörter aus den Tabellen ab `$a6c0`.
5. Diese vier Wörter ersetzen den zuvor gesetzten Bodenquartettblock.

`$426c8` maskiert beide Koordinaten auf fünf Bit. Die reservierte erste
Levelzeile gilt immer als fest; alle anderen Zellen gelten nur dann als feste
Nachbarwand, wenn ihr MO-Code exakt `$8000` ist. Ein blaues Türsegment hat
einen anderen MO-Code und zählt bei diesem Test deshalb nicht als orange
Wand. Das sichtbare Mundstück entsteht aus der Überlagerung der normalen
orangefarbenen Endkappe mit einem transparent gezeichneten Tür-Motion-Object.

### Wie ein Motion Object aus vier RAM-Wörtern wird

Die vier Wörter eines Objekts `n` liegen nicht hintereinander, sondern in vier
1024-Wort-Feldern:

```text
$902000 + 2*n   Code
$902800 + 2*n   X und Palette
$903000 + 2*n   invertiertes Y, X-Flip, Breite und Höhe
$903800 + 2*n   10-Bit-Link
```

Breite und Höhe sind jeweils als `Anzahl minus 1` gespeichert:

```text
width  = ((size_word >> 3) & 7) + 1
height = ( size_word       & 7) + 1
```

Ein Objekt kann somit `1..8` Tiles breit und `1..8` Tiles hoch sein, also bis
zu 64 x 64 Pixel. Der Startcode bezeichnet das Tile links oben. Ohne
X-Flip zählt die Hardware die Codes zeilenweise hoch: erst alle Tiles einer
Zeile von links nach rechts, dann die nächste Zeile.

X wird direkt in 1/128-Pixel-Festkomma vorbereitet; Bits 15-7 sind die
sichtbaren neun Pixelbits. Y ist hardwarebedingt invertiert und bezeichnet
die Unterkante. MAME rekonstruiert daraus sinngemäß:

```text
screen_x = raw_x - x_scroll
screen_y = -raw_y - y_scroll - height*8
```

Das Subtrahieren der vollständigen Höhe ist wichtig: Ein 24 Pixel hohes
Objekt, dessen Unterkante an einer 16-Pixel-Levelzelle hängt, beginnt acht
Pixel oberhalb dieser Zelle.

Die Linkwörter bilden keine einfache lineare Sprite-Liste. Die SLIP-Tabelle
ab `$905f80` enthält für jedes 8-Pixel-Rasterband einen Starteintrag. Von dort
folgt die Motion-Object-Hardware den 10-Bit-Links. Dadurch muss sie pro
Scanline nur die relevante Teilkette besuchen, obwohl im RAM bis zu 1024
Objektslots existieren.

### Tatsächliche Ebenenreihenfolge

Die Schaltung und MAME erzeugen das Bild in dieser Reihenfolge:

1. Motion Objects werden zunächst in einen transparenten Hilfsbitmap
   gerastert.
2. Das Playfield wird in den sichtbaren Bitmap gezeichnet.
3. Jeder nicht transparente MO-Pixel wird mit dem Playfield gemischt.
4. Das Alpha-/Text-Tilemap wird zuletzt darübergelegt.

Gauntlets MO-Format besitzt dabei kein Prioritätsfeld. Ein normaler MO-Pixel
ungleich Pen 0 ersetzt den Playfield-Pixel an derselben Stelle. Deshalb können
Figuren, Generatoren, Items und blaue Wände vor orangefarbenen Wänden stehen,
ohne dass die Wandtiles selbst verändert oder ausgeschnitten werden müssen.

Die Pens bedeuten beim Mischen:

| MO-Pen | Wirkung |
|---:|---|
| 0 | transparent; Playfield bleibt unverändert |
| 1 | keine normale MO-Farbe; Playfield-Farbbit `$80` wird umgeschaltet, bei den üblichen Playfield-Gruppen effektiv gelöscht |
| 2-15 | normaler Motion-Object-Farbpixel ersetzt das Playfield |

Pen 1 ist somit eine hardwareseitige Fleck-/Schattenfunktion. Der Generator
kann Teile des darunterliegenden Bodens oder einer Wand umfärben, ohne dort
eine deckende rechteckige Hintergrundfarbe zeichnen zu müssen. Der
Offline-Renderer hält dafür parallel zum normalen Playfield eine zweite
Version mit gelöschtem Farbbit `$80` bereit.

### Die neun Mündungsformen der blauen Wände

Die logischen Typen `$03` und `$04` werden nicht als Playfield gezeichnet:

- `$03`: horizontale aufschließbare Wand, Routine `$43f0c`
- `$04`: vertikale aufschließbare Wand, Routine `$44080`

Jedes Ende wird in einen von drei Zuständen eingeteilt. Auf der negativen
Achse liefert der Zustand den Grundwert `0`, `3` oder `6`, auf der positiven
Achse den Zusatz `0`, `1` oder `2`; ihre Summe ergibt exakt die Formnummer
`0..8`.

```text
Wert 6/2: der unmittelbar benachbarte Slot ist keine $8000-Wand
Wert 3/1: direkter und übernächster Slot sind $8000-Wände,
          die beiden seitlichen Slots an der Mündung sind frei
Wert 0:   alle übrigen festen Anschlussfälle
```

Die Formnummer wählt getrennte ROM-Tabellen für Code, Versatz und Größe:

| Form | horizontal: Code, X-Versatz, Größe | vertikal: Code, Y-Versatz, Größe |
|---:|---|---|
| 0 | `$9d5a`, 4 px, 3 x 2 | `$9d98`, 0 px, 2 x 3 |
| 1 | `$9d60`, 4 px, 4 x 2 | `$9d9e`, 2 px, 2 x 3 |
| 2 | `$9d3c`, 4 px, 3 x 2 | `$9d7c`, 0 px, 2 x 3 |
| 3 | `$9d68`, 5 px, 3 x 2 | `$9da4`, 0 px, 2 x 4 |
| 4 | `$9d6e`, 5 px, 4 x 2 | `$9dac`, 2 px, 2 x 4 |
| 5 | `$9d42`, 5 px, 3 x 2 | `$9d8c`, 0 px, 2 x 4 |
| 6 | `$9d4c`, 4 px, 3 x 2 | `$9d82`, 0 px, 2 x 2 |
| 7 | `$9d52`, 4 px, 4 x 2 | `$9d86`, 2 px, 2 x 3 |
| 8 | `$9d48`, 0 px, 2 x 2 | `$9d94`, 0 px, 2 x 2 |

Alle Größen sind 8-x-8-Tiles. Horizontale Formen sind daher 16 Pixel hoch
und je nach Mündung 16, 24 oder 32 Pixel breit. Vertikale Formen sind 16
Pixel breit und 16, 24 oder 32 Pixel hoch. Der Versatz und die Übergröße
lassen die transparenten Anschlussgrafiken in die benachbarten Endkappen
laufen. Alle neun Formen kommen im extrahierten Kartensatz in beiden
Ausrichtungen tatsächlich vor.

### Generatoren: Warum sie über den Wänden stehen

Generatoren sind keine Bestandteile des Playfield-Tilemaps. `$441f6` erzeugt
sie als echte Motion Objects aus vier typabhängigen Tabellen:

| Tabelle | Bedeutung |
|---|---|
| `$c534 + 2*type` | erster Grafikcode |
| `$c5ac + 2*type` | X-Versatz in 1/128 Pixel |
| `$c624 + type` | Breite-1 und Höhe-1 |
| `$c660 + type` | MO-Palettengruppe |

Für die Generatorentypen ergeben sich aus den lokalen ROMs:

| Typen | Startcode | Größe | X-Versatz | Palettengruppen |
|---|---:|---:|---:|---|
| `$09-$0b` Knochen-/Geistergenerator, drei Zustände | `$0800` | 3 x 3 | 4 px | 2, 3, 4 |
| `$0c-$0e` Generatorgruppe, drei Zustände | `$09e1` | 3 x 3 | 4 px | 2, 3, 4 |
| `$0f-$11` Generatorgruppe, drei Zustände | `$183f` | 3 x 3 | 4 px | 6, 7, 8 |
| `$12-$14` Generatorgruppe, drei Zustände | `$1b57` | 3 x 2 | 4 px | 9, 10, 11 |
| `$15-$17` Generatorgruppe, drei Zustände | `$13a2` | 3 x 3 | 4 px | 9, 10, 11 |

Die drei Typen einer Gruppe benutzen beim initialen Aufbau dieselben
Grafikcodes und Größen, aber unterschiedliche Paletten. Weitere Animation und
Zustandswechsel können den MO-Eintrag später verändern.

Für einen 3-x-3-Generator in der logischen Zelle `(x,y)` gilt:

```text
linke Kante = 16*x - 4
obere Kante = 16*(y+1) - 3*8 = 16*y - 8
Breite/Höhe = 24 x 24 Pixel
rechte Kante = 16*x + 19
untere Kante = 16*y + 15
```

Seine Levelzelle ist dagegen nur `16*x .. 16*x+15` und
`16*y .. 16*y+15`. Das Objekt ragt folglich vier Pixel nach links und rechts
sowie acht Pixel nach oben aus seiner Zelle heraus. Es ist an der Unterkante
der Zelle ausgerichtet. Eine 3-x-2-Variante ist 24 x 16 Pixel groß und ragt
nur horizontal je vier Pixel über.

Der Generator steht somit aus zwei unabhängigen Gründen über einer Wand:

1. **Geometrie:** Sein Motion-Object-Rechteck darf über die 16-x-16-Zelle und
   damit in benachbarte Wandzellen hineinragen.
2. **Compositing:** Seine Pens 2-15 werden nach dem Playfield gemischt und
   ersetzen dort die Wandpixel; Pen 0 lässt die Wand um die unregelmäßige
   Silhouette herum sichtbar, Pen 1 färbt sie über die Sonderlogik um.

Es gibt also kein speziell ausgeschnittenes Wandtile unter jedem Generator
und auch kein Hardware-Clipping an der Levelzelle. Die Wand bleibt vollständig
im Playfield erhalten; das größere, transparente Generator-Motion-Object wird
einfach danach darübergelegt. Genau derselbe Mechanismus erlaubt Spielern,
Monstern, Schlüsseln und Nahrung, vor Wänden oder teilweise über Wandkanten zu
stehen.

## Scroll- und Steuerregister

### `$930000`: X-Scroll

Das volle Wort scrollt das Playfield. Motion Objects erhalten die unteren neun
Bits. Änderungen können mitten im Frame wirken; ein genauer Port muss daher
Raster-Splits berücksichtigen.

### `$905f6e`: Y-Scroll und Tilebank

```text
15..7  Y-Scroll (untere 9 Ergebnisbits für Playfield/MO)
1..0   Playfield-Tilebank 0..3
```

Die Bank erweitert den 12-Bit-Playfieldcode auf 14 Bit, obwohl nur 8192
Grafiktiles vorliegen; die tatsächlich verwendeten Bank-/Codekombinationen
müssen noch im Programm bzw. in Laufzeit-Traces geprüft werden.

### `$803120-$80312f`: LS259-Ausgangslatch

Die Adresse wählt einen von acht Latch-Ausgängen, Datenbit 0 setzt dessen
Zustand. Ausgang 7 steuert den Reset der Sound-CPU (1 = läuft, 0 = Reset).
Ausgänge 0-3 sind im MAME-Treiber als vermutlich nicht angeschlossene LEDs
vermerkt; 4-6 sind noch zu klären.

## Sound-CPU

| Adresse | Funktion |
|---|---|
| `$0000-$0fff` | RAM, nach `$2000` gespiegelt |
| `$1000` | Antwort an 68010 |
| `$1010` | Kommando vom 68010 |
| `$1020` R/W | Münzen / Mixer: YM 3 Bit, POKEY 2 Bit, TMS5220 3 Bit |
| `$1030` R | Kommando-/Antwortstatus, Speech-ready, Selbsttest |
| `$1030-$1037` W | Sound-Steuerlatch |
| `$1800-$180f` | POKEY |
| `$1810-$1811` | YM2151 |
| `$1820` | TMS5220-Daten |
| `$1830` | periodischen Sound-IRQ quittieren |
| `$4000-$ffff` | ROM |

Der 6502 erhält ein NMI bei neuem Haupt-CPU-Kommando und einen periodischen
IRQ über das 32V-Signal. Die 68010-Seite schreibt das Kommando byteweise nach
`$803171` und liest die Antwort bei `$80300f`.

## Portierungsrelevante Schlussfolgerungen

1. Die gemeinsame 4-bpp-Grafik passt grundsätzlich gut zu Neo Geos C-ROMs,
   muss aber von 8-x-8- in 16-x-16-Zellen umgebaut werden. Playfield und Figuren
   benötigen auf Atari-Seite keinen getrennten Grafikbestand; im MVS-Build kann
   eine getrennte Optimierung trotzdem sinnvoll sein.
2. Das Playfield benötigt eine 64-x-64-Map, X/Y-Scroll, X-Flip und eine
   umschaltbare Tilebank. Da das MVS kein Hardware-Tilemap für scrollende
   Hintergründe besitzt, wird es aus verketteten Line Sprites aufgebaut. Der
   Alpha-Layer wird auf den höher priorisierten FIX-Layer abgebildet.
3. Atari-Motion-Objects sind verkettete Rechtecke von 1-8 x 1-8 Tiles. Sie
   müssen in native 16-x-16-C-Tiles und Neo-Geo-Sprite-Chains übersetzt werden;
   die Grenzwerte von 380 Sprites insgesamt und 96 pro Rasterzeile werden ein
   zentrales Renderbudget.
4. Paletten müssen von Atari-IRGB4444 bewusst in Neo-Geos 16-Bit-Farbformat
   konvertiert werden. Die Intensitätskomponente darf dabei nicht ignoriert
   werden; FIX kann außerdem nur die ersten 16 Neo-Geo-Paletten verwenden.
5. Vor einem vollständigen Codeport müssen Slapstic-Zugriffe, die genaue
   Intensitäts-D/A-Kennlinie, SLIP-Listenaufbau und mögliche Rasteränderungen
   der Scrollregister noch per Trace bestätigt werden.
6. Das 68010-Programm wird nicht binär auf dem MVS weiterverwendet: Trotz der
   verwandten 68k-Architektur unterscheiden sich CPU-Variante, System-ROM-
   Vertrag, Speicherkarte und sämtliche Video-/Soundregister. Ziel ist ein
   nativer 68000-Port der Spiellogik.

## Nächste Reverse-Engineering-Schritte

- 68010-ROM-Image korrekt interleaven und mit Symbolen/Hardwarelabels
  disassemblieren.
- Alle Schreibstellen nach `$910000-$9107ff`, `$905f6e` und `$930000`
  markieren; dadurch finden wir Palettentabellen, Levelbanking und Rastereffekte.
- Playfield-, Alpha- und MO-RAM während eines echten Levels dumpen und daraus
  einen eigenständigen Frame-Renderer bauen.
- Slapstic-104-Zugriffssequenzen identifizieren, bevor Kontrollfluss im Fenster
  `$038000-$039fff` interpretiert wird.
- Die 1024 IRGB4444-Einträge gegen einen MAME-Screenshot rendern und die
  Neo-Geo-Farbkonvertierung visuell verifizieren.
- Ein echtes Level- und Motion-Object-Trace erzeugen, um die Zahl eindeutiger
  2-x-2-Tilekombinationen und das Worst-Case-Spritebudget auf dem MVS zu messen.
