# Time Pilot Port

Dieses Programm baut den Stand von `cloud_multiplex_demo` auf dem
rekonstruierten Originalmodell neu auf:

```text
fester Objektpool -> Renderprojektion -> Basissprites -> Raster-Rewrite-Buffer
```

Slot 0 im Objektpool ist der zentrierte Spieler. Slots 1–7 sind logische
Wolkenobjekte. Jedes Wolkenobjekt wird in zwei Renderinstanzen projiziert, die
sich einen MEGA65-Hardwareslot teilen. Damit entstehen aus sieben logischen
Wolken 14 sichtbare Instanzen.

Die IRQ- und VIC-IV-Routinen bleiben vorerst identisch zum bewährten
Technikdemo. Weitere Objektpools für Schüsse und Gegner werden ausschließlich
vor der Renderprojektion ergänzt.

Die obere 32-Pixel-Zone ist eine VIC-IV-FCM-Tilemap. Ihre Zeichen werden aus
`tm6` sowie den originalen Farb-PROMs erzeugt: `1-UP` und `HI-SCORE` sind rot,
die sechsstelligen Werte weiß. Die HUD-Farben liegen in den freien
Paletteneinträgen `$e0-$ef`; die Spritepaletten belegen `$00-$7f`. Dadurch
überschreibt die HUD-Palette weder die Wolken noch das Spielerschiff.
`tp_hud_set_scores()` aktualisiert beide Werte.

Die drei Reserveschiffe unter dem linken Score sind keine Ersatzgrafik. Die
vier `tm6`-Tiles `$0b,$09/$0c,$0a` stimmen exakt mit den vier 8×8-Quadranten
des aufrechten Spielersprites 232 aus `tm4`/`tm5` überein.

Das aktuelle Layout teilt die 320 Pixel breite FCM-Fläche in ein 224 Pixel
breites Spielfeld (28 Tiles) und eine 96 Pixel breite schwarze HUD-Spalte
(12 Tiles). Unten verwendet `CREDIT` die ROM-Codes
`$77,$d7,$34,$87,$fd,$dc`; die Anzeige startet bei `02` Credits.

Die vier Pfeiltasten wählen wie beim Arcade-Joystick eine absolute
Zielrichtung, einschließlich Diagonalen bei zwei gleichzeitig gehaltenen
Tasten. Das Flugzeug dreht auf dem kürzesten Weg dorthin und behält ohne
Richtungseingabe seinen aktuellen Kurs. Space startet eine Dreiersalve aus
dem festen Pool von sechs Tilemap-Projektilen.

Die Projektile folgen der originalen Software-Sprite-Routine `$5337`. Der
Build konvertiert die vollständige 512-Byte-Tabelle `$53d4-$55d3` aus dem
Z80-ROM und ihre 81 tatsächlich verwendeten Kombinationen aus `tm6`-Tilecode
und Farbattribut. Je nach Subposition werden bis zu vier benachbarte
Tilemapzellen beschrieben; Hardwaresprites werden dafür nicht benötigt.

## Speicherlayout

Das Demo trennt CPU-Laufzeitspeicher und VIC-IV-Grafikdaten dauerhaft:

```text
$0800-$0fff  40x25-FCM-Screen (16-Bit-Zellen)
$1800-$187f  Laufzeitkopie des Spieler-Sprites
$1880-$18ff  gemeinsam verwendete Laufzeit-Wolkengrafik
$1ff0-$1ff7  klassische VIC-Spritepointer
$2001-$3fff  C-Code, Konstanten und BSS
$4000-$41ff  konvertierte Projektil-Lookuptabelle
$4200-$4fff  Reserve
$5000-$58ff  Flugrichtungs-/Spritedaten
$5900-$5fff  Objektmodell-Code
$6000-$7fff  freier C-Stack (wächst von $8000 abwärts)
$8000-$9c7f  VIC-IV-FCM-Zeichen im RAM unter dem BASIC-ROM
```

Der 45GS02 besitzt einen 16-Bit-CPU-Adressraum; deshalb können nicht 64 KiB
C-Code und zusätzlich ein Stack gleichzeitig direkt eingeblendet sein. Große
Grafikbestände gehören in das vom VIC-IV sichtbare RAM unter dem ROM oder
später per DMA in den erweiterten MEGA65-Adressraum. Die CPU-Grenze
`__HIMEM__ = $8000` darf nicht über die ROM-Einblendung angehoben werden.
