# Sprite-Hardware und Multiplexing

## Physische Sprite-Slots

MAME zeichnet die geraden Offsets `$10,$12,...,$3e`; das sind 24 Slots. Für
einen geraden Offset `o` gilt:

| Adresse | Bits | Bedeutung |
|---|---|---|
| `$b000 + o` | 7–0 | X-Position |
| `$b001 + o` | 7–0 | Spritecode 0–255 |
| `$b400 + o` | 5–0 | Farbgruppe 0–63 |
| `$b400 + o` | 6 | Flip X, active-low |
| `$b400 + o` | 7 | Flip Y |
| `$b401 + o` | 7–0 | Hardware-Y; Bildschirm-Y ist `241 - Wert` |

Die Grafik ist 16×16 Pixel groß, Pixelwert 0 ist transparent. Ein logisches
Sprite lässt sich daher so ausdrücken:

```c
struct ArcadeSprite {
    uint8_t x;
    uint8_t code;
    uint8_t color;
    bool flip_x;
    bool flip_y;
    uint8_t y;
};

void write_arcade_sprite(uint8_t offset, const struct ArcadeSprite *s)
{
    ram_b0[offset]     = s->x;
    ram_b0[offset + 1] = s->code;
    ram_b4[offset]     = (s->color & 0x3f)
                       | (s->flip_x ? 0x00 : 0x40)
                       | (s->flip_y ? 0x80 : 0x00);
    ram_b4[offset + 1] = 241 - s->y;
}
```

## Shadow-Sprite-RAM des Programms

Die Spiellogik schreibt nicht fortlaufend direkt in die Hardware. `$0365`
überträgt zu Beginn des NMI zwei Shadow-Bereiche:

- `$aa10-$aa3f`: 24 Paare aus X und Spritecode
- `$aa40-$aa6f`: 24 Paare aus Attribut und logischem Bildschirm-Y

Im normalen, nicht gespiegelten Modus wird Y beim Upload mit
`~(y + 14) == 241 - y` in das Hardwareformat umgerechnet.

Die Prioritäts-/Slotreihenfolge ist nicht linear. Bei logischen Indizes 0–23
lautet die Upload-Reihenfolge für die Hardware-Slots 8–31:

```text
16, 17, 18, 0, 1, 2, ... 15, 19, 20, 21, 22, 23
```

Diese Reihenfolge ist relevant, weil MAME die Slots von Offset `$3e` abwärts
zeichnet und damit die Überdeckungspriorität bestimmt. Der Cocktail-/Flip-
Pfad in `$0556` transformiert Koordinaten separat und wird später ergänzt.

## Acht multiplexte Slots

Die Multiplex-Routinen bearbeiten die Hardwareoffsets:

```text
$10, $12, $14, $36, $38, $3a, $3c, $3e
```

Das entspricht drei Slots am Anfang und fünf am Ende der Hardwareliste – genau
den Shadow-Indizes 16–23. Diese acht logischen Sprites sind damit sehr stark
als die Wolkenobjekte belegt.

Ein aktiver Multiplex-Eintrag hat Bit 7 seines Hardware-Y-Bytes gesetzt. Für
jeden solchen Slot prüft das Original das Z80-Carry von
`scanline + encoded_y`. Die Poll-Variante kehrt zurück, wenn noch kein Carry
auftrat; die blockierende Variante wartet darauf. Danach gilt:

```c
ram_b4[offset + 1] = encoded_y & 0x7f;
ram_b0[offset] += 0x80;
```

Da `encoded_y` Bit 7 gesetzt hat, liegt die Schwelle bei
`256 - encoded_y`. Nach dem ersten Zeichnen wird:

```text
encoded_y' = encoded_y - 128
x'         = x + 128       (8-Bit-Wrap)
screen_y'  = 241 - encoded_y' = screen_y + 128
```

Dasselbe Bild erscheint im selben Frame also nochmals bei
`(x + 128, y + 128)`, jeweils modulo 256. Code, Farbe und Flipbits bleiben
unverändert.

## Übertragung auf den MEGA65

Wir bilden nicht die ungewöhnliche Bit-7-Markierung nach, sondern deren
Bedeutung:

```c
struct SpriteRewrite {
    uint16_t raster_line;
    uint8_t slot;
    uint16_t x;
    uint16_t y;
    uint8_t image;
    uint8_t attributes;
};
```

Pro multiplexter Wolke entstehen ein beim VBlank installiertes Basissprite
und ein Rewrite-Eintrag für dasselbe physische MEGA65-Sprite. Der Raster-IRQ
schreibt Position und nur bei Bedarf Bild/Attribute neu.

Noch zu messen sind der sichere Vorlauf vor der Zielzeile, die notwendigen
VIC-IV-Registerschreibzyklen und mehrere Ereignisse auf derselben Rasterzeile.
Bis dahin ist die Struktur ein logisches, noch nicht gepacktes Format.
