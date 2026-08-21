# Objektverwaltung und Sprite-Pipeline

Diese Beschreibung enthält nur statisch im Z80-ROM bestätigte Strukturen.
Noch nicht sicher identifizierte Objektklassen bleiben bewusst generisch.

## Keine Linked List, sondern feste Pools

Time Pilot verwendet keine verkettete Liste und keine dynamische Allokation.
Das Objekt-RAM ab `$a800` ist in feste 16-Byte-Datensätze gegliedert. Die
Update-Routinen laden bekannte Adressen direkt in `IX` und koppeln sie an einen
festen Shadow-Spriteslot in `IY`:

| Objekt-RAM `IX` | Shadow X/Code `IY` | logischer Slot |
|---:|---:|---:|
| `$a800` | `$aa10` | 0, bestätigter Spieler |
| `$a810` | `$aa12` | 1 |
| `$a820` | `$aa14` | 2 |
| `$a830` | `$aa16` | 3 |
| `$a840` | `$aa18` | 4 |
| `$a850` | `$aa1a` | 5 |
| `$a860` | `$aa1c` | 6 |
| `$a870` | `$aa1e` | 7 |
| `$a880` | `$aa20` | 8 |
| `$a890` | `$aa22` | 9 |
| `$a8a0` | `$aa24` | 10 |
| `$a8b0` | `$aa26` | 11 |
| `$a8c0` | `$aa28` | 12 |
| `$a8e0` | `$aa2c` | 14 |
| `$a8f0` | `$aa2e` | 15 |

Die sieben Routinen `$28b7-$290b` zeigen den Pool `$a850-$a8b0` besonders
deutlich: Sie rufen denselben Dispatcher auf, jeweils mit dem nächsten
16-Byte-Datensatz und dem nächsten Zwei-Byte-Shadow-Slot. `$a8d0` und weitere
Bereiche sind noch semantisch zu klären und werden daher nicht geraten.

## Aktivität und Freigabe

Byte `IX+0` ist das Zustands-/Aktivitätsbyte. Die Dispatcher prüfen es zuerst;
Null bedeutet in den untersuchten Pools „Slot frei/inaktiv“. Andere Werte
bezeichnen aktive Zustände, Explosionen oder Übergänge und sind nicht bloß ein
Boolean.

Routine `$2bde` gibt einen Slot frei:

```c
void release_object(Object16 *o, ShadowSprite *s)
{
    o->state = 0;          // IX+0
    o->x_fraction = 0;     // IX+3
    o->y_fraction = 0;     // IX+5
    s->x = 0;              // IY+0
    s->y = 0;              // IY+0x31
}
```

Ein Spawn sucht beziehungsweise kennt somit einen freien Eintrag im passenden
Pool, initialisiert dessen 16 Byte und den fest zugeordneten Shadow-Slot.
Es muss keine Liste umgehängt werden. „Was ist gerade da?“ ergibt sich aus den
Zustandsbytes aller festen Pools.

## Aufteilung zwischen Objekt und Shadow-Sprite

Der Objektdatensatz enthält Logikzustand und Subpixelwerte; die ganzzahligen
Bildschirmkoordinaten liegen bereits im Shadow-Sprite. Für mehrere bewegliche
Objekte bestätigt `$3e05-$3e35`:

```text
IX+3       X-Subpixelanteil
IX+5       Y-Subpixelanteil
IX+$0a/$0b X-Geschwindigkeit, 16 Bit
IX+$0c/$0d Y-Geschwindigkeit, 16 Bit
IY+0       ganzzahliges X
IY+1       Spritecode
IY+$30     Farbgruppe und Flipbits
IY+$31     ganzzahliges Y
```

Globale Bewegungsanteile aus `$a808/$a80a` werden addiert. Der niederwertige
Teil bleibt im Objekt, der höherwertige Teil wird direkt als neue Position in
den Shadow-Slot geschrieben. Weitere Felder wie `IX+2` (bei Flugzeugen die
Richtung), `IX+4`, `IX+e` und `IX+f` sind klassenabhängig.

## Dispatcher statt Objektmethoden

Der aktive Framepfad `$1199-$11e1` ruft die Objektgruppen in einer festen
Reihenfolge auf. Innerhalb eines Pools wird anhand des Zustandsbytes oder einer
globalen Spielphase zu einem klassenspezifischen Handler verzweigt. Das ist
funktional ein statischer Entity-Component-Pool mit fest verdrahteten
Systemaufrufen, nicht eine polymorphe Liste.

Beispiel `$28a1`: sieben feste Wrapper wählen nacheinander `$a850-$a8b0` und
`$aa1a-$aa26`. Der gemeinsame Dispatcher ab `$290e` wählt einen von mehreren
Bewegungs-/Darstellungsfällen. Einer davon ruft `$2afc` auf und erzeugt über
die Tabelle `$2b18` die bestätigte 16-Richtungs-Gegnergrafik.

## Shadow-RAM und Hardware-Upload

Die Logik schreibt nicht direkt in die Arcade-Spritehardware. Die 24 logischen
Shadow-Slots bestehen aus zwei parallelen Bereichen:

```text
$aa10-$aa3f: 24 × (X, Spritecode)
$aa40-$aa6f: 24 × (Attribut, logisches Y)
```

Am Anfang jedes VBlank-NMI ruft `$00e6` die Routine `$0365` auf. Sie kopiert
den **im vorherigen Frame fertiggestellten** Shadow-Zustand in die physischen
Hardwarebereiche:

```text
$b010-$b03f: X und Spritecode
$b410-$b43f: Attribut und kodiertes Hardware-Y
```

Dabei wird `hardware_y = ~(logical_y + 14) = 241 - logical_y` berechnet. Die
Kopierreihenfolge ist wegen der Spritepriorität nicht linear: Shadow-Slots
16–18, dann 0–15, dann 19–23 werden auf die 24 Hardware-Slots gelegt.

Erst **nach** diesem Upload führt der aktive Spielpfad die Objektupdates aus.
Diese schreiben damit den Shadow-Zustand für den nächsten NMI. Das ergibt eine
klare Frame-Pipeline:

```text
VBlank N:
    Shadow aus Frame N-1 -> Hardware
    Eingabe lesen
    feste Objektpools aktualisieren
    Shadow für Frame N aufbauen

VBlank N+1:
    neuer Shadow -> Hardware
```

## Raster-Rewrite der Wolken

Nach dem VBlank-Upload sind zunächst alle 24 physischen Slots gesetzt. Acht
bestimmte Slots werden während des sichtbaren Bildes wiederverwendet. Die
Routinen `$0f97` und `$1098` warten beziehungsweise prüfen die Rasterposition
und verschieben diese Hardwareeinträge um `(128,128)`. Dabei ändern sie direkt
`$b0xx/$b4xx`; Objektpool und Shadow-RAM bleiben unverändert.

Für den MEGA65 wird dieses zeitabhängige Polling als sortierter
Raster-Rewrite-Buffer dargestellt.

## Portmodell

Wir sollten das feste Poolprinzip beibehalten, aber Logik und Renderer sauber
trennen:

```c
struct GameObject {
    uint8_t state;
    uint8_t type;
    uint8_t direction;
    int16_t x, y;          // Festkomma
    int16_t vx, vy;
    uint8_t timer;
};

struct RenderSprite {
    uint16_t x;
    uint8_t y;
    uint8_t image;
    uint8_t attributes;
    uint8_t priority;
};

void frame(void)
{
    swap_render_buffers_at_vblank();
    update_fixed_object_pools();
    build_render_sprites_from_active_objects();
    assign_physical_sprite_slots();
    build_sorted_raster_rewrite_buffer();
}
```

Anders als das Original sollten MEGA65-Objekte nicht direkt Hardware- oder
Shadow-Slotnummern besitzen. Eine separate Renderplanung kann dann dieselbe
Spiellogik für normale Slots und Multiplex-Rewrites verwenden.
