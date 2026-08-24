# Zielhardware: Neo Geo MVS, Gauntlet für zwei Spieler

Stand: 2026-08-23. Das Ziel ist kein Emulator und kein FPGA-Zwischenziel,
sondern ein bootfähiges **Neo Geo MVS-Modul** mit einer nativen 2-Spieler-
Fassung von Atari Gauntlet.

Technische Hauptquelle ist das originale
[SNK Neo-Geo Programming Manual](https://www.neogeodev.org/NG.pdf). Für
Platinenaufbau und Signale dient zusätzlich das
[SNK MV-1F Service Manual](https://wiki.neogeodev.org/images/b/bd/MV-1FserviceManual.pdf).
Wo dieses Dokument bereits eine Portierungsstrategie nennt, ist sie als
Entwurf gekennzeichnet und kein behauptetes Verhalten der Hardware.

## Zieldefinition

- MVS-kompatibles Modul mit PROG- und CHA-Seite beziehungsweise einer dazu
  elektrisch kompatiblen modernen Modulplatine.
- Zwei Spieler gleichzeitig, je 8-Wege-Joystick und zwei Spieltasten.
- MVS-System-ROM-Integration für Credits, Start/Join, Region, Soft-DIPs,
  Demo-Sound und Multi-Slot-Betrieb.
- 1:1-Pixeldarstellung ohne Skalierung: aus Ataris 336 x 240 werden auf dem MVS
  320 x 224 sichtbare Pixel durch einen symmetrischen Beschnitt von 8 Pixeln
  auf jeder Seite.
- Alle vier Helden bleiben im Spiel. Wie sie auf zwei Controller verteilt
  werden, ist noch eine Produktentscheidung; empfohlen wird eine
  Charakterwahl beim Eintritt eines Spielers.

## Hardwareüberblick

| Bereich | Neo Geo MVS |
|---|---|
| Haupt-CPU | Motorola/Hitachi 68000-kompatibel, 12 MHz |
| Work RAM | 64 KiB; System-ROM reserviert den oberen Teil |
| Sound-CPU | Z80A, 4 MHz, 2 KiB Work RAM |
| Soundchip | Yamaha YM2610: FM, SSG sowie ADPCM-A/B |
| Ausgabe NTSC | 320 x 224 sichtbare Pixel |
| FIX-Layer | 40 x 28 Tiles, 8 x 8 Pixel, 4 bpp, immer vor Sprites |
| Line Sprites | bis zu 380 vertikale Streifen, je 16 x maximal 512 Pixel |
| Rasterlimit | höchstens 96 Line Sprites gleichzeitig auf einer Zeile |
| Sprite-Tile | 16 x 16 Pixel, 4 bpp, 15 sichtbare Farben plus transparent |
| Palette | 256 Paletten x 16 Einträge; zwei umschaltbare RAM-Bänke |
| Interrupts | VBLANK und programmierbarer Pixel-/Rastertimer |

Die offizielle Spezifikation nennt 380 Line Sprites. Jeder besteht aus bis zu
32 vertikal angeordneten 16-x-16-Zeichen. Die Chain-Funktion setzt weitere
Streifen rechts an den vorherigen und ist damit genau der Mechanismus, aus dem
Neo-Geo-Spiele ihre Hintergründe und großen Figuren bauen.

## Unterschied zum Atari-Ausgangssystem

| Atari Gauntlet | Neo Geo MVS | Konsequenz |
|---|---|---|
| 68010, 7,159 MHz | 68000, 12 MHz | Spiellogik portieren, nicht ROM binär starten |
| 336 x 240 | 320 x 224 | je 8 Pixel an allen vier Rändern beschneiden |
| 8-x-8-Playfield-Tiles | 16-x-16-Sprite-Tiles | Tiles offline zu Weltzellen zusammensetzen |
| scrollendes 64-x-64-Tilemap | kein scrollender Tile-Layer | Playfield aus Sprite-Chains bauen |
| 64-x-31-Alpha-Layer | 40-x-28-FIX-Layer | sichtbares 42-x-30-Fenster beschneiden/HUD anpassen |
| verkettete Motion Objects | Line Sprites mit Chains | Objektlisten in SCB-Daten übersetzen |
| 1024 IRGB4444-Farben | 256 x 16 Neo-Geo-Farben pro Bank | Paletten neu gruppieren und konvertieren |
| YM2151 + POKEY + TMS5220 | YM2610 | Soundprogramm, Musik, Effekte und Sprache neu bauen |
| vier Controller | zwei MVS-Controller | Charakterwahl und Join-Regeln definieren |

Der symmetrische 8-Pixel-Beschnitt ist besonders günstig: Er entfernt genau
eine Atari-Tilezeile oben/unten und eine Tile-Spalte links/rechts. Das
Spielbild bleibt pixelgenau. HUD-Elemente müssen trotzdem in den vom SNK-
Handbuch empfohlenen sicheren Bereich von 288 x 208 Pixeln verschoben werden.

## 68000-Speicherkarte

Die folgende Karte enthält die für den Port wesentlichen Basisadressen. Der
MVS-System-ROM-Vertrag ist Teil der Plattform und darf nicht wie ein frei
stehendes JAMMA-Board behandelt werden.

| Adresse | Zugriff | Funktion |
|---|---|---|
| `$000000-$0fffff` | R | direkt sichtbares P-ROM-Fenster |
| `$100000-$10ffff` | R/W | 64 KiB Work RAM |
| `$300000` | R | Spieler 1: Richtung und A-D, active low |
| `$300001` | W byte | Watchdog bedienen |
| `$320000` | R/W byte | Soundantwort lesen / Soundkommando schreiben |
| `$340000` | R | Spieler 2: Richtung und A-D, active low |
| `$380000` | R | Start/Select, Kartenstatus, MVS/AES-Kennung |
| `$380001` | W byte | Controller-Ausgänge |
| `$3a0001-$3a001f` | W byte | Shadow, Vektoren, Karten- und Palettenbanksteuerung |
| `$3c0000-$3c000e` | R/W word | LSPC-/VRAM-/Rasterregister |
| `$400000-$401fff` | R/W word/long | aktive Palette-RAM-Bank |
| `$800000-$bfffff` | R/W | Memory-Card-Fenster |
| `$c00000-$c1ffff` | R | System-ROM |

Das System-ROM reserviert innerhalb des Work RAM `$10f300-$10ffff`. Der
Spielcode verwendet daher regulär `$100000-$10f2ff`. MVS-Backup-RAM wird vom
System verwaltet; persistente Daten sollen über dessen Routinen und nicht über
direkte, boardabhängige Annahmen behandelt werden.

### Vektoren und System-ROM

Nach Reset sind die Systemvektoren aktiv. Die Adressen `$000000-$00007f`
können zwischen Spiel- und System-ROM umgeschaltet werden. Das Modul benötigt
deshalb den korrekten Neo-Geo-Header, die USER-Entry-Points und die vom
System-ROM erwarteten Rückkehrpfade.

Für ein korrektes MVS-Spiel muss die 68000-Seite mindestens:

- den Watchdog spätestens innerhalb des vorgeschriebenen Zeitfensters bedienen,
- den VBLANK-Handler sauber quittieren,
- `SYSTEM-IO` einmal je Frame aufrufen, damit Joysticks, Credits, Coins,
  Start/Join und Multi-Slot-Auswahl korrekt bearbeitet werden,
- Demo und Spiel über die vorgesehenen System-ROM-Rückgaben verlassen,
- regionale Unterschiede bei gemeinsamen oder getrennten Credits respektieren.

## LSPC- und Interruptregister

VRAM ist nicht direkt in den 68000-Adressraum eingeblendet, sondern wird als
16-Bit-Wortstrom über LSPC angesprochen. Byte- und Longword-Zugriffe auf VRAM
sind nicht zulässig.

| Adresse | Funktion |
|---|---|
| `$3c0000` W / R | VRAM-Adresse setzen / VRAM-Daten lesen |
| `$3c0002` W / R | VRAM-Daten schreiben / VRAM-Daten lesen |
| `$3c0004` R/W | automatischer VRAM-Adressschritt |
| `$3c0006` W / R | Modus und Autoanimation / Rasterposition und Status |
| `$3c0008` W | Timer High |
| `$3c000a` W | Timer Low |
| `$3c000c` W | Interrupt-ACK: Bit 1 Timer, Bit 2 VBLANK |
| `$3c000e` W | Timer-Stop-Steuerung des LSPC2 |

Interrupt 1 beginnt mit VBLANK und verwendet Vektor `$64`. Interrupt 2 kommt
vom 32-Bit-Pixeltimer und verwendet Vektor `$68`. Der Zähler läuft mit der
Pixelzeit und kann periodische oder frei verkettete Raster-IRQs erzeugen. Das
ist relevant, falls Gauntlets Scrollregister tatsächlich mitten im Bild
geändert werden; zunächst soll der Port jedoch mit einem Scrollzustand pro
Frame auskommen.

## FIX-Layer

- 40 x 28 sichtbare Zeichen im NTSC-Modus, je 8 x 8 Pixel.
- 4 bpp, 4096 adressierbare Zeichen.
- Farbgruppe 0-15; nur die ersten 16 Neo-Geo-Paletten sind nutzbar.
- FIX liegt immer vor allen Line Sprites und scrollt nicht pixelweise.
- Transparenz ist Pen 0.

Gauntlets Alpha-Layer ist ebenfalls 8 x 8 groß und daher geometrisch nahezu
ideal. Die 512 lokalen Alpha-Tiles werden in S-ROM-Format konvertiert. Das
sichtbare Atari-Fenster umfasst 42 x 30 Zeichen; für MVS entfallen außen je
eine Zeile und Spalte. Scores, Gesundheit, Credits und wichtige Texte werden
anschließend in den 40-x-28-Bereich neu gesetzt.

Offener Punkt: Atari kann 32 Alpha-Farbgruppen mit je vier Pens auswählen,
verteilt über die Hardwareindizes 0-15 und 32-47, und besitzt zusätzlich ein
Opaque-Bit pro Mapwort. FIX bietet 16 Gruppen mit je 16 Pens, aber Pen 0 bleibt
transparent. Die tatsächlich benutzten Alpha-Gruppen und Opaque-Kombinationen
müssen aus einem RAM-Trace bestimmt werden; danach können wir Farben packen
und bei Bedarf Tilevarianten mit umkodierten Penwerten erzeugen.

## Line Sprites und VRAM

Die Sprite-Steuerblöcke sind wortadressiert:

| VRAM | Bedeutung |
|---|---|
| `$0000-$6fff` | SCB1: Tilecode und Attribute, 64 Wörter je Sprite |
| `$7000-$74ff` | FIX-Map im NTSC-Modus |
| `$8000-$81ff` | SCB2: horizontale/vertikale Verkleinerung |
| `$8200-$83ff` | SCB3: Y, Höhe und Chain-Bit |
| `$8400-$85ff` | SCB4: X-Position |

Ein SCB1-Tileeintrag besteht aus zwei Wörtern:

```text
Wort 0: Tilecode Bits 15..0
Wort 1: Palette 15..12, erweiterter Tilecode, Autoanimation,
        Y-Flip und X-Flip
```

SCB2 liefert horizontale und vertikale Schrumpfung. SCB3 enthält die
9-Bit-Y-Position, die Zahl aktiver 16-x-16-Zeichen und das Chain-Bit. SCB4
enthält die 9-Bit-X-Position. Ein Chain-Sprite übernimmt Position, Höhe und
Verkleinerung vom vorherigen Streifen und wird rechts daran gesetzt.

FIX hat stets höchste Priorität. Zwischen Line Sprites entsteht Priorität aus
der Slotreihenfolge; die genaue Slotkonvention wird im ersten Hardwaretest
festgeschrieben, bevor der Gauntlet-Renderer davon abhängig gemacht wird.

## Entwurf für das Gauntlet-Playfield

### Bevorzugter Weg: 2-x-2-Weltzellen

Vier originale 8-x-8-Tiles werden offline zu einem nativen 16-x-16-C-Tile
zusammengesetzt. Ein 320-Pixel-Bild benötigt dann 20 sichtbare Sprite-Spalten;
mit einer gepufferten Scrollspalte sind es 21. Jede Spalte ist ein Line Sprite
mit ungefähr 15 Tileeinträgen. Horizontales und vertikales Pixel-Scrolling
erfolgt über Position und Auswahl dieser Spalten.

Der Haken ist, dass ein C-ROM unveränderlich ist: Nicht nur die 8192
Einzeltiles, sondern jede im Spiel vorkommende 2-x-2-Kombination muss als
fertiges C-Tile vorhanden sein. Türen, zerstörbare Objekte und andere
Mapänderungen brauchen ebenfalls erreichbare Varianten. Deshalb ist das
Extrahieren aller Levelmaps die Grundlage für die C-ROM-Planung.

Dieser Schritt ist inzwischen erledigt: `extracted/levels/` enthält 127
ROM-Karten als logische 32-x-32-Raster. Eine Gauntlet-Zelle ist bereits genau
16 x 16 Pixel groß und passt damit ohne geometrische Umrechnung auf ein
Neo-Geo-C-Tile. Als Nächstes kann ein Offline-Compiler über alle Karten die
tatsächlich vorkommenden Wandnachbarschaften und 2-x-2-Atari-Tilekombinationen
deduplizieren. Dynamische Zustände wie offene Türen und zerstörte Wände müssen
zusätzlich aus den Objekt- und Update-Routinen in diese Variantenmenge
aufgenommen werden.

### Fallback: vertikale 2-x-1-Weltzellen

Je zwei übereinanderliegende Atari-Tiles bilden ein 8 x 16 großes Motiv in
einem transparenten 16-x-16-C-Tile. Das benötigt etwa 40-41 Line Sprites für
den Hintergrund, reduziert aber die Zahl möglicher Kombinationen. Es bleibt
weniger Rasterbudget für Gegner und Effekte.

### Nicht geeigneter generischer Ansatz

Jedes 8-x-8-Tile einzeln transparent in ein 16-x-16-Tile einzubetten und die
geraden/ungeraden Zeilen über getrennte Vollbildstreifen zu zeichnen, würde
etwa 80-84 gleichzeitig aktive Line Sprites verbrauchen. Damit blieben vom
96er-Rasterlimit höchstens 12-16 für alle Spieler, Gegner und Geschosse. Dieser
Ansatz wird nur als Diagnosemodus betrachtet.

## Entwurf für Motion Objects

Atari beschreibt Figuren als Rechtecke von 1-8 x 1-8 8-Pixel-Tiles. Für MVS
sollen beobachtete Objektframes offline zu 16-x-16-C-Tiles kompiliert werden.
Ein maximales 64-x-64-Objekt wird dann zu einer Chain aus vier Line Sprites mit
je vier Tileeinträgen, statt dutzende transparente 8-Pixel-Ersatzsprites zu
verbrauchen.

Der Compiler braucht aus jedem Atari-MO:

```text
Tilebasis, Breite, Höhe, X-Flip, Palette und Framezugehörigkeit
```

Die vollständige Laufzeitliste muss getraced werden. Erst danach kennen wir:

- alle tatsächlich benötigten zusammengesetzten Frames,
- das maximale Gesamtbudget von 380 Sprite-Slots,
- die maximale gleichzeitige Rasterlast von 96 Streifen,
- die korrekte Priorität bei Überlappungen,
- die Behandlung des Atari-Sonderpens 1, der Playfield-Farbbit `$80` ändert.

Für Sonderpen 1 ist wahrscheinlich eine vorberechnete alternative
Playfield-Palette oder ein gezieltes Overlay nötig; Neo Geo bietet keine
direkte Entsprechung zu dieser Atari-Mischlogik.

Der Zwischenexport zeigt Pen 1 im Diagnoseatlas als Schwarz mit Alpha 128.
Eine parallele Binärmaske hält diese Pixel unabhängig von der Vorschau fest.
Beim endgültigen Level-Build wird die Alpha-Darstellung nicht übernommen,
sondern aus der lokalen Hintergrundfarbe eine möglichst passende deckende
Neo-Geo-Schattenfarbe gewählt. Pen 0 bleibt durchgehend die echte
Transparenz.

### Generatoren und Wandüberdeckung auf dem MVS

Die ursprüngliche Ebenenwirkung darf beim Zusammensetzen zu 16-x-16-C-Tiles
nicht verloren gehen. Ein Gauntlet-Generator ist typischerweise 24 x 24 Pixel
groß, vier Pixel gegenüber seiner Levelzelle nach links verschoben und an
deren Unterkante ausgerichtet. Er ragt daher vier Pixel nach links und rechts
sowie acht Pixel nach oben über seine 16-x-16-Zelle hinaus. Diese Überhänge
dürfen nicht in ein einzelnes Weltzellen-Tile abgeschnitten werden.

Für den MVS-Renderer folgt daraus:

1. Playfield-Spalten werden als die hinteren Line-Sprite-Chains aufgebaut.
2. Generatoren bleiben eigenständige transparente Objekt-Chains mit ihrer
   originalen 24-x-24- beziehungsweise 24-x-16-Geometrie.
3. Ihre Sprite-Slots werden in der getesteten höheren Zeichenreihenfolge als
   die Playfield-Spalten ausgegeben, sodass sichtbare Objektpens die Wand
   überdecken; FIX/HUD bleibt weiterhin ganz oben.
4. Pen 0 bleibt transparent. Atari-Pen 1 wird beim Asset-Build in eine
   vorberechnete Schatten-/Farbvariante oder ein separates Overlay übersetzt.

Orange Wand und Generator werden also auch auf dem Neo Geo nicht zu einem
Sondertile verschmolzen. Das erhält dieselbe Lösung wie auf Atari: eine
vollständige Wand hinten und ein größeres, transparentes Objekt davor. Dieselbe
Regel gilt für die überlappenden blauen Wandmündungen.

## Palette

Neo Geo stellt pro aktiver Bank 256 Paletten mit je 16 Einträgen bereit. Pen 0
ist transparent; damit bleiben 15 sichtbare Farben pro Palette. Die zweite
Palette-RAM-Bank kann atomar zugeschaltet werden. Palettenzugriffe sollen laut
SNK nur während Blankings erfolgen, weil Zugriffe während der sichtbaren
Abtastung Bildstörungen erzeugen können.

Vorgesehene Aufteilung:

| Paletten | Verwendung |
|---|---|
| 0-15 | FIX/HUD und vom System-ROM benötigte Einträge |
| 16-31 | Gauntlet Motion Objects |
| 32-39 | Gauntlet Playfield |
| ab 40 | Effekte, Sonderpen-Varianten und Reserve |
| 255 | Backdrop gemäß Neo-Geo-Konvention |

Das ist nur eine logische Startbelegung. Das originale Alpha-Format und die
vom MVS-System-ROM belegten FIX-Farben müssen vor der endgültigen Vergabe
geprüft werden. Die Farbkonvertierung von Atari-IRGB4444 in Neo-Geos verteilte
RGB-Bits samt Dunkelbit wird als eigenes, visuell getestetes Tool umgesetzt.

### Titelbild-Prototyp

`make title-screen-neogeo` zerlegt das 320-x-224-Titelbild in 20 x 14 Tiles.
Schwarz wird Pen 0 und damit transparent; jeder Tile besitzt höchstens 15
weitere Farben. Die auffälligen Ersatzfarben für die animierte Logo-Rampe
werden unverändert erhalten. Nur bei 15 der 280 Bildschirmtiles ist eine
Reduktion nötig, die 248 Pixel betrifft. Kompatible lokale Farbmengen werden
zu 63 Sprite-Paletten in den Bänken 16 bis 78 zusammengelegt.

Der Build schreibt 278 deduplizierte logische 4-bpp-Grafiktiles, eine
spaltenweise Tilemap für 20 vertikale Sprite-Chains und ein vollständiges
8-KiB-Palette-RAM-Abbild. Das logische Tile-Binary packt zunächst zwei Pens pro
Byte. `tools/convert_neogeo_crom.py` erzeugt daraus zusätzlich das native Paar
`title-screen-neogeo-c1.bin`/`title-screen-neogeo-c2.bin`. C1 enthält die
Bitplanes 0/1, C2 die Bitplanes 2/3; jeder Tile belegt in jeder Datei 64 Byte.
Der Konverter prüft jeden Tile durch eine verlustfreie Rückdekodierung. Nur die
spätere Auffüllung auf die Kapazität der konkret gewählten ROM-Chips bleibt als
Platinen-Verpackungsschritt offen.

### Bootfähiges MVS-Titeldemo

`programs/gauntlet_neogeo_demo/` baut daraus eine vollständige Cartridge mit
P1-, S1-, M1-, V1-, C1- und C2-ROM. Die ersten 256 C-Tiles bleiben für das
System transparent reserviert; das Titel-Tileset beginnt bei Code 256. Das
68000-Programm lädt das 8-KiB-Palettenabbild und setzt 20 unabhängige Line
Sprites mit je 14 Tiles auf. S1 ist transparent, M1 verwendet `nullsound` und
V1 bleibt für das stille Demo leer.

Der Builder erzeugt außerdem `gaunttitle.zip`, eine lokale `neogeo.xml` und
ein quelloffenes `nullbios`. `make smoke` bootet die Cartridge headless in
MAME, nimmt nach drei Sekunden einen 320-x-224-Screenshot auf und verwirft
einen schwarzen beziehungsweise unvollständigen Start als Fehler. Der aktuelle
Build wurde mit MAME 0.227 bis zur stabilen Watchdog-Schleife bei `$0002F4`
ausgeführt und zeigt das Titelbild auf der emulierten MVS-Videohardware.

## Eingaben und 2-Spieler-Regeln

Arbeitsbelegung:

| MVS-Eingabe | Gauntlet |
|---|---|
| Joystick | 8-Wege-Bewegung |
| A | Angriff/Feuer |
| B | Magie |
| C, D | frei, Diagnose oder Komfortfunktion |
| Start 1/2 | Spieler starten beziehungsweise während des Spiels beitreten |

Die Eingänge sind active low. Im normalen Spiel sollte die Logik die vom
System-ROM gepflegten Input- und Creditdaten nutzen, nicht Coins direkt lesen.
Japanische/asiatische und US-/europäische MVS-System-ROMs behandeln Start und
Credits teilweise verschieden; ein echtes Modul muss alle Regionen testen.

Empfohlene 2P-Regel: Jeder neu eintretende Spieler wählt aus Warrior, Valkyrie,
Wizard und Elf. Damit bleibt Gauntlets Vier-Helden-Design erhalten, ohne die
Charaktere dauerhaft an P1/P2 zu binden. Doppelte Charakterwahl und die genaue
Auswirkung auf Farben/Statusfelder bleiben eine Designentscheidung.

## Soundziel

Das Original-Soundprogramm kann nicht übernommen werden:

- Atari: 6502, YM2151, POKEY und TMS5220.
- MVS: Z80A und YM2610 mit FM, SSG, ADPCM-A und ADPCM-B.

Das M-ROM enthält einen neuen Z80-Treiber. Musik wird für YM2610-FM neu
instrumentiert oder offline in ADPCM überführt; Effekte und TMS5220-Sprache
werden als ADPCM-Samples neu kodiert. Der 68000 sendet Soundcodes byteweise an
`$320000`, der Z80 quittiert beziehungsweise antwortet über dieselbe Adresse.

Eine frühe spielbare Version darf Musik zunächst weglassen, muss aber Angriff,
Treffer, Magie, Münze und die ikonischen Sprachsamples unterstützen. So bleibt
der Soundpfad klein genug, um Video und Spiellogik zuerst zu stabilisieren.

## Modul-ROMs

| ROM-Gruppe | Inhalt für das Projekt |
|---|---|
| P | 68000-Programm, Tabellen und native Spiellogik |
| S | FIX-Zeichen für HUD, Text und Systemanzeigen |
| C | 16-x-16-Sprite-/Playfieldgrafik in paarweise verschachteltem Format |
| M | Z80-Soundprogramm |
| V | YM2610-ADPCM-Samples und gegebenenfalls Musikdaten |

Vorläufige Größen dürfen erst nach Levelmap- und Objektkompilierung festgelegt
werden. Als Größenordnung sind die Rohdaten günstig: 8192 native
16-x-16-C-Tiles belegen bei 4 bpp genau 1 MiB. Zusammengesetzte Weltzellen,
Objektframes und Varianten erhöhen diesen Wert; daraus folgen erst später die
konkrete C-ROM-Paarung und die Wahl einer kompatiblen CHA-/PROG-Platine.

## Risiken und Messpunkte

1. **96-Sprites-pro-Zeile:** Hintergrund plus Gegnerhorden müssen in echten
   Worst-Case-Szenen gemessen werden.
2. **Unveränderliche C-ROM-Grafik:** dynamische 2-x-2-Mapkombinationen dürfen
   den Tilebestand nicht explodieren lassen.
3. **64 KiB Work RAM:** Weltzustand, Objektlisten, Stacks und Systemreserve
   brauchen früh ein festes Speicherbudget.
4. **FIX-Paletten/Opaque:** Gauntlets Alpha-Layer passt geometrisch, aber nicht
   ohne Analyse aller Farb- und Transparenzkombinationen.
5. **Sonderpen 1:** die Atari-Pixelmischung muss visuell äquivalent ersetzt
   werden.
6. **Sound-Neuaufbau:** Sprache ist direkt konvertierbar, Musik und POKEY-
   Effekte benötigen Arrangement beziehungsweise Ersatz.
7. **MVS-Vertrag:** Multi-Slot, alle Regionen, Soft-DIPs, Credits, Watchdog und
   Systemrückkehr müssen auf echter Hardware sowie im Emulator getestet werden.

## Nächster Zielhardware-Meilenstein

Ein minimales MVS-ROM-Set soll:

1. über das System-ROM korrekt booten,
2. den Watchdog und beide Interrupts bedienen,
3. beide Joysticks sowie A/B anzeigen,
4. eine konvertierte Gauntlet-Palette laden,
5. Alpha-Tiles im FIX-Layer darstellen,
6. einen gescrollten 21-Spalten-Testhintergrund aus C-ROM-Tiles zeigen,
7. darüber zwei verkettete Testfiguren zeichnen.

Erst wenn dieser Test auf echter MVS-Hardware innerhalb des 96er-Rasterlimits
stabil läuft, wird die eigentliche Gauntlet-Spiellogik daraufgesetzt.
