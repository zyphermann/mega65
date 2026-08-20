# Bestätigte Befunde

Diese Notizen trennen Beobachtungen im ROM von noch offenen Interpretationen.
Adressen beziehen sich auf `timepilot-main.asm`.

## Start und NMI

- `$0000` springt nach `$07b1`.
- `$07b1` prüft zunächst Code an `$6000` (außerhalb der drei Time-Pilot-ROMs),
  setzt den Stack auf `$b000`, löscht die Latch-Ausgänge ab `$c300`, schaltet
  Video über `$c308` ein und springt zur Initialisierung bei `$0069`.
- `$0069` löscht Spriteattribute und das gesamte Work-RAM `$a800-$afff`.
  Dazwischen wird mehrfach `$c200` geschrieben, also der Watchdog bedient.
- `$0066`, der Z80-NMI-Vektor, springt nach `$00d8`. Dort werden beide
  Registerbänke sowie IX/IY gesichert. Damit ist `$00d8` der zentrale
  Frame-/VBlank-Pfad.
- Im NMI-Pfad `$0113-$012b` werden System-, Spieler- und DIP-Eingänge gelesen,
  invertiert und nach `$a9ae-$a9b1` kopiert. Die Originalhardware verwendet
  also active-low Eingänge, während die Spiellogik mit gesetzten Bits arbeitet.

## Rasterabhängiges Sprite-Rewrite

Die Bereiche `$0f97-$1097` und `$1098-$1198` sind der bislang wichtigste
Hardwarefund. Beide bearbeiten dieselben acht Sprite-Slots:

```text
Attribut/Y: $b411, $b413, $b415, $b437, $b439, $b43b, $b43d, $b43f
X/Code:     $b010, $b012, $b014, $b036, $b038, $b03a, $b03c, $b03e
```

Pro Slot geschieht erkennbar Folgendes:

1. Bit 7 des Hardware-Y-Bytes muss gesetzt sein.
2. Die aktuelle Rasterzeile wird von `$c000` gelesen und zum Attribut addiert.
3. Bei Carry wird Bit 7 des Attributs gelöscht.
4. Die X-Position wird um `$80` verschoben.

Das Löschen von Bit 7 verschiebt zugleich die Hardware-Y-Koordinate. Da die
Hardware `screen_y = 241 - encoded_y` verwendet, erscheint das zweite Exemplar
128 Pixel weiter unten **und** 128 Pixel weiter rechts.

Das bestätigt MAMEs Kommentar nicht nur allgemein, sondern zeigt die konkrete
Implementierung des Wolken-Multiplexings. `$0f97` prüft ohne Warten und kehrt
zurück; `$1098` wartet pro aktivem Slot auf den Rasterzeitpunkt. Die genaue
Aufrufreihenfolge und die Rolle beider Varianten müssen wir noch vollständig
verfolgen.

Für den MEGA65 lässt sich daraus bereits eine erste Abstraktion ableiten: Ein
Frame erzeugt eine sortierte Liste aus `(Rasterzeile, Sprite-Slot, neue X/Y-
Werte)`. Der Raster-Handler arbeitet diese Liste ab und schreibt die nächste
Belegung in die Hardware-Sprite-Register. Die konkrete Datenstruktur legen wir
erst fest, nachdem alle Aufrufer und Slot-Konventionen bestätigt sind.

Das vollständige Registerlayout und die Shadow-RAM-Zuordnung stehen in
[`sprite-hardware.md`](sprite-hardware.md); der vorläufige Frameablauf in
[`frame-flow.md`](frame-flow.md).

## Noch nicht als Code vertrauenswürdig

Das lineare Listing disassembliert auch Tabellen. Automatisch erzeugte Labels
oder scheinbare Sprünge sind daher allein noch kein Beweis für ausführbaren
Code. Besonders die Warnung über vermeintlich selbstmodifizierenden Code ist
zunächst als Disassembler-Artefakt zu behandeln. Als nächstes markieren wir
vom Reset- und NMI-Pfad erreichbare Bereiche und trennen anschließend Tabellen
über eine `z80dasm`-Blockdatei ab.
