# Arbeitsplan: Time Pilot auf dem MEGA65

## Ziel und Grundregeln

Wir portieren das **beobachtbare Spielverhalten**, nicht die Z80-Instruktionen.
Das Z80-ROM bleibt Referenz. Spiellogik wird verständliches C; nur zeitkritische
MEGA65-Hardwarezugriffe werden Assembler. Jede Erkenntnis erhält ROM-Adresse,
Eingaben, Ausgaben und einen Test, bevor sie als bestätigt gilt.

Der Port bleibt während der gesamten Arbeit baubar. `flight_demo` und das
bisherige `timepilot` bleiben als unabhängige Technikdemos erhalten.

## Geplante Verzeichnisstruktur

```text
reverse-engineering/timepilot/
  timepilot-main.asm       generiertes Rohlisting
  hardware.sym             bestätigte Hardware- und Routinenamen
  blocks.def               bestätigte Code-/Datenbereiche
  findings.md              belegte Erkenntnisse mit ROM-Adressen
  ram-map.md               Namen und Bedeutung von RAM-Variablen
  frame-flow.md            rekonstruierter Ablauf eines Frames
  routines/                C-Pseudocode einzelner Originalroutinen

programs/timepilot/
  main.c                   Zustandsmaschine und Hauptschleife
  game.c/.h                portable Spiellogik
  objects.c/.h             Spieler, Gegner, Schüsse und Wolken
  renderer.c/.h            logische Anzeigeobjekte
  mega65_video.s/.h        Raster-IRQ und Sprite-Rewrites
  generated/               konvertierte ROM-Grafik und Tabellen

shared/timepilot/
  original_data.*          gemeinsam nutzbare Grafik-/Palettendaten
  fixed_math.*             getestete Festkomma-/Vektorfunktionen
```

Die Dateien entstehen erst, wenn ihr Inhalt benötigt wird; die Struktur ist
keine Aufforderung, leere Module anzulegen.

## Phase 1: Verlässliches Z80-Listing

1. ROM-Prüfsummen und Zuordnung `$0000-$5fff` bei jeder Generierung prüfen.
2. Von Reset `$0000`, NMI `$0066` und allen direkten Sprüngen aus erreichbaren
   Code verfolgen.
3. Sprungtabellen und indirekte Aufrufe gesondert erfassen.
4. Bereiche außerhalb des erreichbaren Codes als Byte-, Wort- oder
   Pointertabellen in `blocks.def` markieren.
5. Routinen erst nach bestätigter Funktion dauerhaft benennen.
6. Listing nach jeder Blockänderung erneut erzeugen und kontrollieren, dass
   die ROM-Bytes vollständig und unverändert abgebildet werden.

**Fertig, wenn:** Reset- und NMI-Pfad korrekt disassembliert sind, bekannte
Tabellen nicht mehr als Befehle erscheinen und keine benannte Routine nur auf
einer Vermutung beruht.

## Phase 2: Hardwarezugriffe inventarisieren

Für jeden Zugriff werden Adresse, Leser/Schreiber, Bitbedeutung und aufrufende
Routine dokumentiert:

- Tile- und Farb-RAM `$a000-$a7ff`
- Work-RAM `$a800-$afff`
- beide Sprite-RAM-Bänke `$b000` und `$b400`
- Rasterzeile/Soundkommando `$c000`
- Watchdog/DIP `$c200`
- Eingänge und Latches `$c300-$c360`

Zusätzlich erstellen wir eine Sprite-Slot-Tabelle: Eigentümer, Lebensdauer,
Priorität, Spritecode, Farbe und Raster-Rewrite. Die acht bereits gefundenen
Multiplex-Slots werden zuerst verfolgt.

**Fertig, wenn:** Jeder Hardwarezugriff einer verständlichen Operation
zugeordnet ist und die 24 physischen Sprite-Slots erklärt sind.

## Phase 3: Frame-Ablauf und RAM-Modell

1. NMI ab `$00d8` bis zum vollständigen Register-Restore verfolgen.
2. Aufrufgraph in tatsächlicher Reihenfolge dokumentieren.
3. Für `$a800-$afff` eine RAM-Karte aufbauen. Jede Variable erhält Adresse,
   Größe, Wertebereich, Besitzer und Lebensdauer.
4. Eingabebits und Flankenerkennung rekonstruieren.
5. Spielzustände wie Attraktmodus, Start, laufendes Spiel, Tod, Levelwechsel
   und Game Over identifizieren.
6. Framezähler, Timer und Zufallszahlengenerator bestimmen.

**Fertig, wenn:** Ein Frame als C-artiger Ablauf beschrieben werden kann und
alle darin verwendeten RAM-Felder bekannt oder ausdrücklich als unbekannt
markiert sind.

## Phase 4: Routinen semantisch nach C übersetzen

Für jede Routine entsteht zunächst Pseudocode mit dieser Kopfzeile:

```text
Originaladresse:
Aufrufer:
Eingaben (Register/RAM):
Ausgaben und Seiteneffekte:
Hardwarezugriffe:
Offene Fragen:
```

Übersetzungsreihenfolge:

1. Eingabe und Frame-Timing
2. Spielerrotation und Bewegungsvektoren
3. Wolkenpositionen und Multiplex-Vorbereitung
4. Schüsse
5. Gegnererzeugung, Bewegung und Formationen
6. Kollisionen
7. Punkte, Leben, Level und Spielzustände
8. Tilemap/HUD
9. Soundkommandos

Z80-Eigenheiten werden explizit nachgebildet: 8-/16-Bit-Überlauf,
vorzeichenbehaftete Werte, BCD/`DAA`, Carry-basierte Vergleiche und
Festkommaarithmetik. Wir verwenden feste Integerbreiten; kein `float`.

**Fertig, wenn:** Die Routine ohne Z80-Register verständlich ist und bekannte
Testvektoren dieselben Zustandsänderungen liefern.

## Phase 5: Referenztests

Für kritische Routinen erzeugen wir aus MAME kurze Zustandsprotokolle pro
Frame: Eingaben, relevante RAM-Felder, Sprite-RAM und Soundkommandos. Falls
nötig instrumentieren wir eine lokale MAME-Debug-Sitzung oder verwenden
Breakpoints/Watchpoints; die ROMs selbst werden nicht verändert.

Die portable C-Logik erhält dieselben Startzustände. Verglichen werden:

- Spielerwinkel, Position und Geschwindigkeit
- Wolkenpositionen und erzeugte Rewrite-Ereignisse
- Gegner-/Schusszustände
- Kollisionsresultate
- Punkte, Timer und Zustandswechsel

Ein visueller Vergleich allein genügt nicht. Erst Zustandsvergleich, danach
Screenshot-/Videovergleich.

**Fertig, wenn:** Ein festgelegter Eingabeablauf über mehrere hundert Frames
ohne unerklärte Abweichung reproduziert wird.

## Phase 6: MEGA65-Runtime und Raster-Rewrite-Buffer

Spiellogik und Rendering werden entkoppelt:

```text
Eingabe -> update_game() -> logische Objekte -> build_render_plan()
        -> Basissprites + sortierter Rewrite-Buffer -> Raster-IRQ
```

Vorgesehener Rewrite-Eintrag:

```c
struct SpriteRewrite {
    uint16_t raster_line;
    uint8_t slot;
    uint16_t x;
    uint8_t y;
    uint8_t image;
    uint8_t attributes;
};
```

Die endgültige gepackte Struktur wird anhand der MEGA65-Zyklusbudgets gewählt.
Der Frame-Code baut ausschließlich den nächsten Buffer auf. Beim VBlank werden
Front- und Backbuffer atomar getauscht. Der Raster-Handler liest keine
Spielobjekte, sortiert nichts und alloziert keinen Speicher; er arbeitet nur
die vorbereiteten Einträge ab.

Messpunkte:

- maximale Einträge pro Rasterzeile
- Zyklen je Register-Rewrite
- früheste/späteste sichere Rasterposition
- IRQ-Jitter und Konflikte mit VIC-IV-/DMA-Aktivität
- Verhalten bei überfülltem Buffer

**Fertig, wenn:** Mindestens die 24 Originalslots plus acht Wiederverwendungen
stabil und ohne Flackern dargestellt werden und ein Überlauf deterministisch
behandelt wird.

## Phase 7: Inkrementeller Spielaufbau

Jeder Meilenstein muss auf echter Hardware oder Xemu steuerbar und separat
prüfbar sein:

1. Originalpalette und ROM-Grafik
2. zentrierter Spieler mit originaler Rotation
3. originalgetreue Wolken inklusive Multiplexing
4. Schießen und Projektillebensdauer
5. eine Gegnerart mit Bewegung
6. Kollision, Explosion und Punkte
7. vollständige Epochen-/Gegnerfolge
8. HUD, Leben, Highscore und Spielzustände
9. Sound-Z80-Analyse und MEGA65-Soundumsetzung

Nach jedem Schritt laufen `make all`, Logiktests und der passende Emulator-
Smoke-Test. Optimiert wird erst nach korrektem Verhalten und Messung.

## Phase 8: Abnahme

Der Port gilt als belastbar, wenn:

- alle Programme weiterhin mit `make all` bauen;
- festgelegte Referenzsequenzen deterministisch reproduzierbar sind;
- Rotation, Geschwindigkeiten, Spawnmuster und Kollisionen dem Original folgen;
- Wolken und andere Multiplex-Sprites keine sichtbaren Sprünge erzeugen;
- 50/60-Hz-Unterschiede bewusst behandelt und dokumentiert sind;
- keine Spiellogik im Raster-IRQ steckt;
- verbleibende Abweichungen in einer eigenen Liste begründet sind.

## Unmittelbar nächste Arbeitsschritte

1. Ende und Aufrufgraph des NMI-Pfads `$00d8` bestimmen.
2. Aufrufer von `$0f97` und `$1098` analysieren und beide Varianten exakt
   benennen.
3. Die acht Multiplex-Slots bis zu ihrer Initialisierung zurückverfolgen.
4. Erste `ram-map.md` für `$a980-$a9ff` anlegen, da dort Eingaben und viele
   Framezustände liegen.
5. Danach die erste Originalroutine als dokumentierten C-Pseudocode erstellen.
