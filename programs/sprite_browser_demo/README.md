# Time Pilot Sprite Browser

Das Demo zeigt alle 256 aus `tm4` und `tm5` dekodierten 16×16-Sprites.

- Links/Rechts: Spritecode 0–255
- Oben/Unten: acht bewusst künstliche Fallback-Paletten
- Q: Ende

`SPRITE 000` bezeichnet den tatsächlichen Hardware-Spritecode. `PALETTE 000`
zeigt die gewählte Fallback-Palette. Die originalen PROM-Farbgruppen werden
erst in einem späteren Schritt zugeordnet.

Die Originalhardware kennt ausschließlich 16×16-Sprites. Das ROM speichert
keine Größenangabe. Scheinbar größere Bilder im dicht gepackten PNG können
benachbarte Einzelbilder sein; zusammengesetzte Spielobjekte benötigen mehrere
der 24 Hardware-Sprite-Slots und werden vom Z80-Programm positioniert.

Die dekodierte Bank ist zweigeteilt: Codes 128–255 liegen bei `$4000-$7fff`,
Codes 0–127 bei `$8000-$bfff`. Dadurch muss kein Sprite durch den I/O- oder
KERNAL-Bereich ab `$c000` geladen werden. Für die erste Hälfte wird beim
Kopieren lediglich das BASIC-ROM-Overlay kurz ausgeblendet. Der ausgewählte
128-Byte-Frame landet bei `$3f00`, innerhalb des Bereichs der klassischen
8-Bit-VIC-Spritepointer.

Die acht Spritepointer selbst liegen explizit bei `$3e00`. Die standardmäßige
Position am Ende des Screen-RAM darf in CHR16/FCM nicht benutzt werden: Acht
Pointerbyte würden dort vier Zwei-Byte-Tilemapzellen überschreiben.

## Identifizierte Serien

- Codes 232–247: Spielerrotation; 232 oben, 240 links, 247 fast unten
- Codes 40–47: Gegnerrotation; 40 oben, 47 fast unten

Die stabilen symbolischen Konstanten dazu stehen in
`shared/time_pilot_sprite_codes.h`.
