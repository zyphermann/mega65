# Time Pilot: Reverse Engineering des Z80-Hauptprogramms

Ziel ist keine direkte Übersetzung jeder Z80-Instruktion. Wir rekonstruieren
zuerst das Verhalten des Originals und implementieren anschließend dieselben
Subsysteme sauber für den MEGA65. Das originale Raster-/Spriteverhalten dient
dabei als Spezifikation für den geplanten Raster-Rewrite-Buffer.

## Reproduzierbares Listing

```sh
make disassemble
```

Der Aufruf prüft Größe und SHA-1 der drei Programm-ROMs, fügt `tm1`, `tm2` und
`tm3` nur temporär zu einem 24-KiB-Abbild zusammen und erzeugt
`timepilot-main.asm`. Im Repository verbleibt deshalb keine zusätzliche Kopie
des Binär-ROMs. Voraussetzung ist `z80dasm` (`brew install z80dasm`).

Das erste Listing ist absichtlich linear. Es enthält Adressen, Opcode-Bytes,
automatisch erkannte Sprungziele und die bekannten Hardwareregister. Tabellen,
Grafikparameter und echter Programmcode sind darin noch nicht zuverlässig
voneinander getrennt. `timepilot-main.symbols` ist ein Arbeitsprodukt des
Disassemblers; stabile Namen tragen wir in `hardware.sym` beziehungsweise
später in eine eigene Datei für rekonstruierte Routinen ein.

## Bekannte Ankerpunkte

| Adresse | Bedeutung |
|---:|---|
| `$0000` | Reset-Vektor |
| `$0066` | NMI-Vektor; MAME löst ihn am VBlank aus, wenn er freigegeben ist |
| `$a000-$a3ff` | Farb-/Attribut-RAM der 32×32 Tilemap |
| `$a400-$a7ff` | Tilecode-RAM der 32×32 Tilemap |
| `$a800-$afff` | allgemeines RAM |
| `$b000-$b0ff` | Sprite-X und Spritecode; gespiegelt |
| `$b400-$b4ff` | Spriteattribut und Sprite-Y; gespiegelt |
| `$c000` lesen | aktuelle Rasterzeile |
| `$c000` schreiben | Soundkommando an den Audio-Z80 |
| `$c200` lesen/schreiben | DIP-Schalter 2 / Watchdog |
| `$c300-$c30f` schreiben | 74LS259-Latch: NMI, Flip, Sound-IRQ, Video, Münzzähler |
| `$c300/$c320/$c340` lesen | System-, Spieler-1- und Spieler-2-Eingaben |
| `$c360` lesen | DIP-Schalter 1 |

MAME dokumentiert als entscheidenden Spezialfall, dass das Programm `$c000`
liest, um Wolken-Sprites rasterabhängig ein zweites Mal mit 128 Pixeln Versatz
zu zeichnen. Genau diese Zugriffe sind die ersten Kandidaten für unsere
Raster-Rewrite-Buffer-Abstraktion.

## Rekonstruktionsplan

Der detaillierte, phasenweise Arbeits- und Prüfplan steht in [`PLAN.md`](PLAN.md).
Der aktuelle Frame-Pseudocode steht in [`frame-flow.md`](frame-flow.md), das
Sprite-Registermodell in [`sprite-hardware.md`](sprite-hardware.md).

Quelle für Speicherkarte und Hardwareverhalten ist der
[offizielle MAME-Time-Pilot-Treiber](https://github.com/mamedev/mame/blob/master/src/mame/konami/timeplt.cpp).
