# Atari Gauntlet II – grafische Rekonstruktion

## Ergebnis

Der ROM-Satz in `assets/gaunt2` ist als eigener, reproduzierbarer Build erfasst.
`make` erzeugt:

- 512 entpackte 8×8-Alpha-/Zeichensatz-Tiles;
- 12.288 entpackte 8×8-Playfield-/Motion-Object-Tiles;
- PNG-Übersichten beider Tile-Sätze;
- einen Dump der 1.024 IRGB4444-Palettenwörter samt CSV;
- 102 normal nummerierte Karten, zwei Demo-Karten, elf Treasure Rooms und zwei
  Secret Rooms als ASCII-TXT und 512×512-PNG.

Aufruf:

```sh
make -C reverse-engineering/gauntlet2
```

Die Werkzeuge sind gemeinsam mit Gauntlet I parametrisiert:
`tools/extract_gauntlet_graphics.py --game gaunt2` und
`tools/extract_gauntlet_levels.py --game gaunt2`.

## ROM- und Grafiklayout

Gauntlet II läuft auf derselben Atari-Gauntlet-Plattform: MC68010, 6502,
64×64-Playfield, 64×32-Alpha-Layer, verkettete Motion Objects und vier Bänke
zu je 256 Paletteneinträgen. Der geschützte Bereich liegt weiterhin bei
`$038000-$03FFFF`, verwendet nun aber Slapstic 137412-106.

Der Zeichensatz-ROM `136043-1104.6p` enthält 8 KiB beziehungsweise 512
nichtleere 2-bpp-Tiles. MAME beschreibt eine 16-KiB-Region; die obere Hälfte
ist unbestückt/Nullfüllung und bringt keine zusätzlichen Bilder.

Der gemeinsame Playfield-/MO-Satz wächst von 256 auf 384 KiB. Er besteht aus
vier gleich großen Bitplanes zu je 96 KiB. Die vier 16-KiB-ROMs 1123–1126
werden jeweils einmal gespiegelt (`ROM_RELOAD`) und bilden dadurch vollständige
32-KiB-Abschnitte. Nach planarer Dekodierung entstehen 12.288 Tiles. Wie bei
Gauntlet werden die ROM-Bits invertiert und die X-Bits MSB-zuerst gelesen.

## Geschützte Leveldaten

Die Level-ROMs 1105/1106 werden byteweise even/odd zu 32 KiB verschränkt und
in vier physische 8-KiB-Bänke geteilt. Bank 3 enthält bei Offset `$1FE0` eine
2-Bit-Banknummer für jeweils einen Verzeichniseintrag. Die Bankbereiche sind:

| ROM-ID | Bank |
|---:|---:|
| 0–32 | 0 |
| 33–62 | 1 |
| 63–88 | 2 |
| 89–116 | 3 |

Bank 0 beginnt mit einem Zeiger auf das Verzeichnis. Das Verzeichnis startet
bei CPU-Adresse `$03800C`, enthält 117 nichtleere 32-Bit-Zeiger und endet direkt
vor dem ersten Datensatz bei `$0381E0`.

### Gauntlet-II-Kompression

Die 68010-Routine bei `$04C1BC` bestätigt den Decoder. Sie ähnelt Gauntlet I,
ist aber nicht binär identisch:

- Der Header ist 11 statt 14 Byte lang.
- Die vier Wörterbuchbytes stehen an Header-Offets 7, 9, 8 und 10.
- Die Ausgabe beginnt weiterhin bei Zelle 32; Zeile 0 wird anschließend mit
  Typ `02` gefüllt.
- Kommandoklassen sind weiterhin die oberen zwei Bits `00/40/80/C0`.
- Der besondere Loader-Marker ist `02` statt `01`.
- Wörterbuch-Slots 1 und 3 schreiben vertikal nach oben, die anderen linear.

Jeder Datensatz expandiert deterministisch auf 1.024 logische Metatiles
(32×32, je 16×16 Pixel). Bei Wörterbuchklasse `00` schreiben Slot 1 und 3
vertikal; entscheidend ist die Slotnummer und nicht der gespeicherte Bytewert,
denn zwei Slots dürfen denselben Typ enthalten. Die ASCII-Datei bewahrt
unbekannte Semantik als zweistellige Hex-Typnummer.

## Renderer und derzeitige Aussagegrenze

Das statische Grundbild nutzt dieselbe Hardware-Reihenfolge wie Gauntlet I:
erst das vollständige Playfield, danach die Motion-Object-Overlays. Beim Kopieren
in das spaltenweise organisierte 64×64-PF-RAM negiert Gauntlet II beide
Metatile-Koordinaten: `(x,y) -> (-x,-y) mod 32`. Die PNG-Ausgabe führt diese
Transformation aus; die TXT-Datei zeigt weiterhin die unveränderte logische
ROM-Reihenfolge.

Headerbyte 5 wählt die beiden grafischen Levelthemen: Das obere Nibble ist der
Bodensatz und liefert den Tile-Offset `Nibble × $30`, das untere Nibble ist der
Mauersatz in der Tabelle ab `$00A6C0`. Level 1 enthält `$61` (Boden 6,
Mauer 1), Level 2 `$24` (Boden 2, Mauer 4). Die Typen `02` und `04` bis `09`
sind dabei solide Mauerfamilien. Ihre acht Nachbarn bilden weiterhin die Maske
für `$009C24`; der resultierende Formindex liefert Enden, Ecken, Kreuzungen und
Einmündungen. Zu jedem der vier Tilewörter kommt `$7000` für Playfield-
Farbgruppe 7. PF-RAM-Dumps der laufenden Level 1 und 2 bestätigen die daraus
berechneten Quartette.

Die Palettenwahl benutzt zusätzlich Headerbyte 6. Dessen Nibbles wählen Boden-
und Mauerfarbsatz. Für Mauer-Tilefamilien `0` bis `5` beginnt die Farbtabelle
bei `$05D7E8`, für Familien ab `6` bereits bei `$05D7C8`; dadurch verschiebt
sich der gewählte Satz um einen Eintrag. Anschließend erzeugt die Routine bei
`$05FD80` die von Motion-Object-Pen 1 sichtbaren Gruppen 16 und 23 durch eine
sättigende IRGB-Subtraktion von `$7000` aus den normalen Gruppen 24 und 31.
Insbesondere Level 16 benötigt sowohl diese Tabellenverschiebung als auch die
pro Level neu berechnete Pen-1-Palette.

Level 2 zeigt zwei weitere wichtige Fälle. Typ `01` benutzt dieselben
Bodenformen mit dem zusätzlichen Attribut `$2000` und erzeugt die hellen,
gesprenkelten Bahnen. Typ `3F` sind die roten, in die graue Mauer eingesetzten
Formen. Sie liegen als vier normale Playfield-Tiles in Farbgruppe 4 vor und
sind ausdrücklich keine Grunts oder Motion Objects. Drei kosmetische
Tilequartette werden im Spiel zyklisch verwendet; der statische Export friert
die Auswahl reproduzierbar ein.

Die EXIT-Felder sind gegenüber Gauntlet I auf die Typen `10` und `11`
verschoben und vollständig Teil des Playfields. Typ `10` ist der normale
`EXIT`-Block; `11` wählt die alternative zweizeilige Beschriftung.
Ein PF-RAM-Dump aus Level 1 bestätigt für `10` das Quartett
`$039E,$039F,$0006,$0006` und für `11` das dort sichtbare `EXIT TO 6` aus
`$039E,$039F,$03A0,$03A1`. Diese Typen dürfen nicht zusätzlich als Motion
Objects gezeichnet werden, weil deren Pen-1-Fläche die Schrift wieder
überfärben würde.

Die Gauntlet-II-spezifischen Motion Objects wurden ebenfalls gegen RAM-Dumps
der laufenden Level 1 und 2 abgeglichen. Dazu gehören unter anderem:

| Typ | Darstellung |
|---:|---|
| `0D` | horizontales aufschließbares Tor aus überlappenden 2×2/3×2/4×2-MOs |
| `0E` | vertikales aufschließbares Tor mit 2×4-Anfang und 2×2-Fortsetzungen |
| `13` | Grunt; in Level 2 als 2×2-Gruppe von vier Einträgen vorhanden |
| `14` | Drachen-/Dämonensegment; vertikale Drachen wechseln sichtbar von `$183F` auf `$1990` |
| `15` | großes 3×2-Entity/Enemy-Objekt |
| `1E` | Knochenhaufen |
| `1F`, `20`, `21`, `22`, `24` | Generator-/Entity-Varianten |
| `2E` | Schatzkiste |
| `31` | Essen |
| `32` | Trank |
| `35` | Schlüssel |

Generatoren und große Objekte werden erst nach dem vollständigen Playfield
gezeichnet. Sie dürfen deshalb über Mauerkanten stehen; MO-Pen 1 schaltet dabei
wie auf der Hardware die spezielle Playfield-Farbvariante frei. Gegner- und
Startmarker erhalten im statischen PNG eine reproduzierbare Anfangsgrafik,
während ihre Position im laufenden Spiel naturgemäß sofort dynamisch wird.

Eine Besonderheit zeigt Level 6: Der Loader legt Typ `14` zunächst mit MO-Code
`$183F` an. Die drei vertikalen Segmente bleiben in diesem Ruhezustand, solange
sie außerhalb des Viewports liegen. Sobald der Hardware-Scroll sie sichtbar
macht, ersetzt die Spiellogik alle drei Codes durch `$1990`; erst diese
überlappenden 3×3-MOs ergeben den zusammenhängenden Drachen. Horizontale
Typ-`14`-Reihen bleiben in der beobachteten Situation bei `$183F`. Der statische
Renderer bildet diese kontextabhängige Auswahl nach.

## Secret Rooms und ROM-Datensatznummern

Ein Secret Room ist kein regulär nummeriertes Level. Das ist nun direkt durch
die Aufrufer im 68010-Code belegt und nicht nur aus den Kartenmotiven abgeleitet:

- `$904004` enthält die im HUD ausgegebene Levelnummer; `$904000` enthält die
  davon getrennte interne Raumnummer.
- Der normale Fortschritt wird beim EXIT ab `$052DC8` vorbereitet. Der Code
  erhöht die sichtbare Nummer, übernimmt zunächst den aktuellen ROM-Datensatz
  und addiert danach `1 + $90400E` auf die interne Raumnummer.
- `$052ECA` hält den normalen Ring im Bereich `0..101`. Die auf den VGMaps-
  Karten und in unseren Referenzläufen sichtbare Route benutzt `$90400E = 1`,
  also Schrittweite zwei. Deshalb folgen nach den festen Datensätzen `0..5`
  die ungeraden Datensätze `7,9,…,101` und danach die geraden Datensätze
  `6,8,…,100`.
- `$044E1E` setzt bei erfüllter geheimer Bedingung die interne Raumnummer
  ausdrücklich auf `$73` oder `$74`, also ROM-Datensatz 115 oder 116. Der
  anschließende UI-Pfad ab `$044F7E` verwendet den im ROM stehenden Text
  `SECRET ROOM`.
- Der andere Sonderpfad lädt die Datensätze 104 bis 114 und verwendet den Text
  `TREASURE ROOM`. Das sind exakt elf Treasure Rooms.
- Die beiden Datensätze 102 und 103 werden von den Demo-/Attract-Pfaden geladen.

Damit ist Level 7 kein Secret Room. Es ist auf der Zweierschritt-Route der
ROM-Datensatz 7 und wurde bisher irreführend als `level-008` ausgegeben.
Entsprechend ist ROM-Datensatz 11 das sichtbare Level 9; das erklärt den
Vergleich mit der externen Karte ohne angenommene, linear eingeschobene Räume.

Der Export benennt nun nach der sichtbaren Referenzroute:

| Dateien | ROM-Datensätze | Bedeutung |
|---|---:|---|
| `level-001` … `level-006` | 0 … 5 | feste Anfangsfolge |
| `level-007` … `level-054` | 7, 9, …, 101 | erste Hälfte der Zweierschritt-Route |
| `level-055` … `level-102` | 6, 8, …, 100 | zweite Hälfte der Zweierschritt-Route |
| `demo-001` … `demo-002` | 102 … 103 | Demo/Attract |
| `treasure-room-01` … `treasure-room-11` | 104 … 114 | Treasure Rooms |
| `secret-room-01` … `secret-room-02` | 115 … 116 | echte Secret Rooms |

Nach dem Ende des Rings können sichtbare Nummern weiterlaufen, während
Raumdatensätze wiederverwendet werden. Außerdem erlaubt `$90400E` andere
Schrittweiten. Eine sichtbare Levelnummer ist deshalb außerhalb der hier
festgehaltenen Referenzroute keine unveränderliche Eigenschaft eines
ROM-Datensatzes. Die TXT-Kopfzeile und `index.txt` bewahren immer zusätzlich
die rohe `ROM_RECORD_ID` auf.

Visuelle Gegenproben: [VGMaps Demo und Levels 1–8](https://vgmaps.com/Atlas/Arcade/GauntletII-Demo&Levels-1-8.png),
[Levels 9–17](https://vgmaps.com/Atlas/Arcade/GauntletII-Levels-9-17.png) sowie
[Levels 99–103 und Secret Rooms](https://vgmaps.com/Atlas/Arcade/GauntletII-Levels-99-103&SecretRooms.png).

## Palette und lokaler PROM-Hinweis

Die Farben liegen nicht fest in den Grafik-ROMs, sondern werden zur Laufzeit in
`$910000-$9107FF` aufgebaut. Ein Dump vom Titelbild ist nicht verwendbar:
Gauntlet II hält dort eine andere, stark grüne Playfield-Palette im RAM. Das
Makefile wartet den Selbsttest und Titelaufbau ab, wirft automatisiert eine
Münze ein, wählt mit dem zweiten Aktionsknopf eine Figur und dumpt bei Frame
1650 die 1.024 big-endian IRGB4444-Wörter aus dem laufenden ersten Level.

Der lokale Satz enthält `74s287-136037-103.4r`; aktuelle MAME-Versionen erwarten
für Gauntlet II den Namen `82s129-136043-1103.4r` mit anderer Prüfsumme. Der
Build stellt den vorhandenen 256-Byte-PROM deshalb nur im temporären MAME-ROM-
Verzeichnis unter dem erwarteten Namen bereit. MAME meldet bewusst eine
Prüfsummenwarnung. Die ROM-Dateien in `assets/gaunt2` werden nie verändert.

Auch die Playfield-Palette ist levelabhängig. Headerbyte 6 enthält zwei
Tabellenindizes: Das obere Nibble wählt die Bodenpalette ab `$05D5C8`, das
untere die Mauerpalette ab `$05D7E8`; jeder Eintrag umfasst 16 IRGB4444-Wörter.
Level 1 enthält `$1D`, Level 2 `$D1`. Für Level 2 wurden zusätzlich die vom
Spiel abgeleiteten Gruppen 16 bis 30 (Stain-, Sonderboden- und Zwischenstufen)
gegen einen exakten Laufzeitdump übernommen. Zur Verifikation wurde nur in
einer temporären MAME-ROM-Kopie Verzeichniseintrag 0 auf Leveldatensatz 2
umgebogen. Dadurch lädt das unveränderte Spiel den vollständigen zweiten
Datensatz samt dessen Headerlogik; der Bestand unter `assets/gaunt2` bleibt
unangetastet.

## Relevanz für Neo Geo MVS

Für den MVS-Port sind drei Datenströme getrennt zu halten:

1. logische 32×32-Leveltypen;
2. aus Nachbarschaft und Typ abgeleitete statische Playfield-Tiles;
3. überlagerte, teils mehrteilige Motion Objects.

Die zusätzlichen 4-bpp-Tiles erhöhen den Rohumfang auf 768 KiB im entpackten
8×8-Format. Für Neo Geo müssen sie in 16×16-Sprites umgepackt und die Atari-
Palettegruppen auf Neo-Geo-Palettenbänke abgebildet werden. Die Level-TXT-Dateien
sind dabei die stabile logische Quelle; die PNGs dienen als visuelle Kontrolle.
