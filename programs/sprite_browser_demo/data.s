        .segment "HUDDATA"
        .incbin "generated/hud.bin"

        ; Codes 128..255 are kept below $8000, where no ROM or I/O overlay
        ; can interfere with the browser's CPU copy.
        .segment "SPRITEDATA2"
        .incbin "../../shared/generated/time-pilot-sprites.bin", 16384, 16384

        ; Codes 0..127 occupy the BASIC-ROM window. main.c briefly exposes
        ; its underlying RAM while copying a selected frame.
        .segment "SPRITEDATA1"
        .incbin "../../shared/generated/time-pilot-sprites.bin", 0, 16384
