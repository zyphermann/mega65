# Time Pilot ROM-Dumps

Die Dateien in diesem Verzeichnis entsprechen bytegenau dem originalen
`timeplt`-ROM-Set, das MAME für **Time Pilot (Centuri)** beschreibt. Alle elf
lokalen SHA-1-Prüfsummen stimmen mit der offiziellen MAME-ROM-Definition
überein.

## Übersicht

| Datei | Größe | MAME-Region / Adresse | Inhalt und Zweck |
|---|---:|---|---|
| `tm1` | 8192 Byte | `maincpu`, `$0000-$1FFF` | Erster Teil des Z80-Hauptprogramms, einschließlich Start-/Resetbereich. |
| `tm2` | 8192 Byte | `maincpu`, `$2000-$3FFF` | Zweiter Teil des Z80-Hauptprogramms. |
| `tm3` | 8192 Byte | `maincpu`, `$4000-$5FFF` | Dritter und letzter Teil des Z80-Hauptprogramms. |
| `tm7` | 4096 Byte | `timeplt_audio:tpsound`, `$0000-$0FFF` | Programm des separaten Sound-Z80. Steuert zwei AY-3-8910-Soundchips und die analogen RC-Filter. |
| `tm6` | 8192 Byte | `tiles`, Offset `$0000` | 2-Bitplane-Grafik für 512 Hintergrund-/Zeichentiles mit jeweils 8×8 Pixeln und vier Pixelwerten. |
| `tm4` | 8192 Byte | `sprites`, Offset `$0000` | Erste Hälfte der 2-Bitplane-Spritegrafik: Spritecodes 0–127. |
| `tm5` | 8192 Byte | `sprites`, Offset `$2000` | Zweite Hälfte der Spritegrafik: Spritecodes 128–255. Zusammen mit `tm4` entstehen 256 Sprites mit 16×16 Pixeln und vier Pixelwerten. |
| `timeplt.b4` | 32 Byte | `proms`, Offset `$0000` | Erster 32×8-Paletten-PROM; liefert einen Teil der gewichteten RGB-Bits. |
| `timeplt.b5` | 32 Byte | `proms`, Offset `$0020` | Zweiter 32×8-Paletten-PROM; ergänzt die RGB-Bits. `b4` und `b5` erzeugen gemeinsam 32 physische RGB-Farben. |
| `timeplt.e9` | 256 Byte | `proms`, Offset `$0040` | 256×4-Lookup-Tabelle für Sprites. Das untere Nibble wählt eine der Palettenfarben 0–15. |
| `timeplt.e12` | 256 Byte | `proms`, Offset `$0140` | 256×4-Lookup-Tabelle für Zeichen/Tiles. Das untere Nibble wählt eine der Palettenfarben 16–31; MAME benötigt für Time Pilot nur die ersten 128 Einträge. |

## Programm-ROMs

`tm1`, `tm2` und `tm3` bilden zusammen einen lückenlosen 24-KiB-ROM-Bereich
des Haupt-Z80 von `$0000` bis `$5FFF`. Die Trennung folgt den drei physischen
8-KiB-ROM-Bausteinen; MAME behandelt sie nicht als drei fachlich getrennte
Module. Spielablauf, Eingabe, Kollisionslogik, Spriteverwaltung und
Bildschirmaufbau können daher ROM-übergreifend verteilt sein.

Time Pilot besitzt einen zweiten Z80 für Audio. Dessen 4-KiB-Programm ist
`tm7`. Der Soundprozessor erhält Kommandos vom Hauptprozessor und bedient zwei
AY-3-8910 mit insgesamt sechs Tonkanälen. Zusätzlich schaltet er verschiedene
RC-Tiefpassfilter.

## Grafik-ROMs

Die Grafikdaten sind keine fertigen RGB-Pixel. Jeder Pixel hat zunächst nur
einen 2-Bit-Wert von 0 bis 3:

- `tm6`: 512 Tiles × 8 × 8 Pixel × 2 Bit = 8192 Byte
- `tm4` + `tm5`: 256 Sprites × 16 × 16 Pixel × 2 Bit = 16384 Byte

MAME beschreibt die ungewöhnliche Bit-/Nibble-Anordnung in `charlayout` und
`spritelayout`. Für eine korrekte Konvertierung müssen diese Layouts
nachgebildet werden; ein lineares Lesen der Bits liefert keine korrekt
angeordneten Bilder.

`tools/extract_timepilot_sprites.py` dekodiert `tm4` und `tm5` zu allen 256
Sprites, dreht sie für einen normalen Landscape-Bildschirm um 90 Grad nach
rechts und erzeugt unter `shared/generated/` eine 4-bpp-Binärdatei, einen
256×256-Pixel-Übersichts-PNG und einen Header mit den Formatkonstanten. Die
Vorschau verwendet absichtlich nur feste Fallback-Farben für Pixelwerte 0–3;
die Sprite-PROM-Farbzuordnung wird dabei noch nicht angewendet.

Ein Tile oder Sprite wählt zusätzlich eine Farbgruppe. Die Kombination aus
Farbgruppe und 2-Bit-Pixel ergibt einen Index in `e12` beziehungsweise `e9`.
Erst diese Lookup-Tabelle verweist auf eine der 32 echten Farben aus `b4` und
`b5`.

## Palette und Lookup-PROMs

Die beiden 32-Byte-PROMs `b4` und `b5` sind gemeinsam die eigentliche
Hardwarepalette. Für jeden der 32 Einträge setzt MAME fünf gewichtete Bits pro
RGB-Kanal zusammen. Die Gewichte modellieren das Widerstandsnetzwerk des
Arcadeboards.

Die 256-Byte-Dateien `e9` und `e12` enthalten dagegen nur Werte von `$0` bis
`$F`; ihr oberes Nibble ist in den vorliegenden Dumps immer null. Es handelt
sich somit logisch um 256×4-Bit-PROMs:

- `e9`: Sprite-Farbgruppen → Farben 0–15
- `e12`: Tile-Farbgruppen → Farben 16–31; bei 32 Gruppen × 4 Pixelwerten verwendet MAME 128 der 256 vorhandenen Einträge

Damit war die ursprüngliche Vermutung genau umgekehrt: Nicht die zwei
256-Byte-Dateien erzeugen RGB-Farben, sondern die zwei 32-Byte-Dateien.

## Prüfsummen

| Datei | SHA-1 |
|---|---|
| `tm1` | `c72f30988ac00cbe6549b71c3bcb414511e8b997` |
| `tm2` | `ab517efa93ae7be780af55faea82a6e83edd828c` |
| `tm3` | `ef98a1abb45b22d7498a0aca520f43bbee248b22` |
| `tm4` | `cbe2ccd2cd503af62f009cd5aab73aa7366230b1` |
| `tm5` | `5dd30d3fb9fd8cf9e6a8e37e7ea858c7fd038a7e` |
| `tm6` | `07221875e3f81d9def67c57a7ccd82d52ce65e01` |
| `tm7` | `408fca4515e8af84211df3e204c8776b2f8adb23` |
| `timeplt.b4` | `f62e279e21fce171231d3139be7adabe1f4b8c2e` |
| `timeplt.b5` | `9ad275365eba4869f94749f39ff8705d92056a10` |
| `timeplt.e9` | `678433b21aae1daa938e32d3293eeed529a42ef9` |
| `timeplt.e12` | `151bd2dff4e4ef76d6438c1ab2cae71f987b9dad` |

## Quellen

- [MAME: Time Pilot-Treiber, ROM-Definition, Grafiklayouts und Palette](https://github.com/mamedev/mame/blob/master/src/mame/konami/timeplt.cpp)
- [MAME: gemeinsames Time-Pilot-Audiogerät](https://github.com/mamedev/mame/blob/master/src/mame/shared/timeplt_a.cpp)

Stand der Prüfung: 20. August 2026, MAME-Quellzweig `master`.
