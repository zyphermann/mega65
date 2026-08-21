# Vorläufiger Ablauf eines Frames

Stand: statisch aus dem Haupt-ROM hergeleitet. Namen mit `unknown_` sind noch
nicht semantisch bestimmt. Das Original führt praktisch die gesamte
Framearbeit im VBlank-NMI aus.

## Bestätigter Kontrollfluss

```text
$0066  NMI-Vektor
  -> $00d8  Register sichern
     -> $0365  logische Sprites in Hardware-Sprite-RAM übertragen
     -> $5286  gepufferte Tilemap-Schreibaufträge bearbeiten
     -> Flip-/Framefreigabe bestimmen
     -> Eingänge und DIP-Schalter lesen
     -> Framezähler und drei bekannte Timer aktualisieren
     -> $48be  noch unbekannte Frame-Hilfsroutine
     -> Spielzustand über Sprungtabelle aufrufen
     -> $55d4  höchstens ein gepuffertes Soundkommando senden
     -> Register wiederherstellen
     -> $018b RET
```

Die Sprungtabelle bei `$015f` wird mit `state & 3` aus `$a9ab` ausgewählt:

| Zustand | Ziel | Bedeutung |
|---:|---:|---|
| 0 | `$15c2` | noch zu bestimmen |
| 1 | `$1651` | noch zu bestimmen |
| 2 | `$17fe` | noch zu bestimmen |
| 3 | `$0f1f` | enthält den umfangreichen aktiven Spielpfad; genaue Abgrenzung offen |

Die Bytes hinter den vier Tabellenzeigern sind Daten und dürfen nicht als
linear anschließender Code interpretiert werden.

## C-artiger Pseudocode

```c
void timepilot_vblank_frame(void)
{
    save_all_z80_registers();

    upload_shadow_sprites_to_arcade_hardware();       // $0365
    process_deferred_tile_writes();                   // $5286

    write_latch(NMI_ENABLE, false);
    kick_watchdog();

    orientation_flag = 1;                             // $a987
    if (cocktail_or_transition_condition())
        orientation_flag = alternate_orientation();
    write_latch(FLIP_SCREEN, orientation_flag);

    input.dsw2    = ~read8(0xc200);                   // $a9ad
    input.system  = ~read8(0xc300);                   // $a9ae
    input.player1 = ~read8(0xc320);                   // $a9af
    input.player2 = ~read8(0xc340);                   // $a9b0
    input.dsw1    = ~read8(0xc360);                   // $a9b1

    ++frame_counter;                                  // $a980, uint8 wrap
    bcd_frame_counter = daa(bcd_frame_counter + 1);   // $a9ce
    decrement_if_nonzero(0xa817);
    decrement_if_nonzero(0xa812);
    decrement_if_nonzero(0xa8f4);

    unknown_frame_helper_48be();

    switch (game_state & 3) {                         // $a9ab
        case 0: state_0_15c2(); break;
        case 1: state_1_1651(); break;
        case 2: state_2_17fe(); break;
        case 3: state_3_0f1f(); break;
    }

    send_one_queued_sound_command();                  // $55d4
    write_latch(NMI_ENABLE, true);                    // $0184-$0187
    restore_all_z80_registers();
}
```

`write_latch(NMI_ENABLE, false)` entspricht dem Schreibzugriff auf `$c300`.
Kurz vor dem Rücksprung liest das Original die Konstante `1` aus ROM-Adresse
`$1600` und schreibt sie nach `$c300`; damit wird der nächste NMI freigegeben.

## Aktiver Spielpfad und Rasterarbeit

Im langen Spielpfad ab `$1199` werden Objekt-/Kollisionsroutinen nacheinander
aufgerufen. Zwischen diesen Aufrufen erscheint `$0f97` fünfmal. Am Ende folgt
`$1098`. Das ist eine Zeitverteilung innerhalb des sichtbaren Bildes:

```c
update_object_group_a();
update_object_group_b();
update_object_group_c();
update_object_group_d();

rewrite_cloud_sprites_that_are_due();                 // nicht blockierend
update_more_objects();
rewrite_cloud_sprites_that_are_due();
update_more_objects();
rewrite_cloud_sprites_that_are_due();
update_more_objects();
rewrite_cloud_sprites_that_are_due();
update_more_objects();
rewrite_cloud_sprites_that_are_due();
update_final_objects_and_tilemap();
wait_and_rewrite_all_remaining_cloud_sprites();       // blockierend
```

Die konkreten Objektnamen sind noch nicht bestätigt. Sicher ist aber: Das
Original besitzt keinen Ereignispuffer. Es verteilt Polling-Aufrufe über die
Spiellogik und wartet am Ende auf noch ausstehende Rasterpositionen. Unser
MEGA65-Port ersetzt dieses CPU-Timing durch vorbereitete Rasterereignisse.

## Vorgeschlagener MEGA65-Frame

```c
void mega65_frame(void)
{
    wait_for_vblank();
    swap_rewrite_buffers();
    install_base_sprite_state();

    poll_inputs(&next_input);
    update_game(&game, &next_input);
    build_render_plan(&game, &render_plan);
    build_sprite_rewrite_buffer(&render_plan, back_buffer);
}
```

Der Raster-IRQ arbeitet nur den bereits sortierten Frontbuffer ab. Dadurch
hängt das Timing nicht von der Laufzeit einzelner C-Spielroutinen ab.

Die bestätigte Verwaltung der festen 16-Byte-Objektpools und ihre Kopplung an
die 24 Shadow-Sprites ist in [`object-model.md`](object-model.md) beschrieben.
