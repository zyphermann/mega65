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
