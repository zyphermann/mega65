; Minimal consumer for the frame schedule prepared by sprite_multiplexer.c.

        .setcpu         "65C02"

        .import         _smux_debug_enabled
        .import         _smux_event_count
        .import         _smux_event_image
        .import         _smux_event_raster
        .import         _smux_event_slot
        .import         _smux_event_x
        .import         _smux_event_x_msb
        .import         _smux_event_y
        .import         _smux_front
        .import         _smux_irq_event
        .import         _smux_swap_pending
        .import         callirq

        .export         initirq
        .export         doneirq
        .interruptor    smux_raster_irq, 30

MAX_EVENTS         = 64
VIC_SPRITE_X       = $d000
VIC_SPRITE_Y       = $d001
VIC_SPRITE_X_MSB   = $d010
VIC_SPRITE_ENABLE  = $d015
VIC_CTRL1          = $d011
VIC_RASTER         = $d012
VIC_IRQ_STATUS     = $d019
VIC_BORDER         = $d020
SPRITE_POINTERS    = $1ff0
KERNAL_IRQ_VECTOR  = $0314
EVENT_ENABLE       = $fe

        .segment        "ONCE"
initirq:
        lda     KERNAL_IRQ_VECTOR
        ldx     KERNAL_IRQ_VECTOR+1
        sta     saved_irq_jump+1
        stx     saved_irq_jump+2
        lda     #<irq_stub
        ldx     #>irq_stub
        jmp     set_irq_vector

        .segment        "CODE"
doneirq:
        lda     saved_irq_jump+1
        ldx     saved_irq_jump+2
set_irq_vector:
        sei
        sta     KERNAL_IRQ_VECTOR
        stx     KERNAL_IRQ_VECTOR+1
        cli
        rts

smux_raster_irq:
        lda     VIC_IRQ_STATUS
        and     #$01
        bne     raster_irq
        clc
        rts
raster_irq:
        lda     #$01
        sta     VIC_IRQ_STATUS

process_event:
        jsr     load_index
        ldy     _smux_event_slot,x
        cpy     #EVENT_ENABLE
        beq     enable_event

        lda     sprite_bit,y
        sta     current_bit
        lda     _smux_event_image,x
        sta     SPRITE_POINTERS,y
        tya
        asl     a
        tay
        lda     _smux_event_x,x
        sta     VIC_SPRITE_X,y
        lda     _smux_event_y,x
        sta     VIC_SPRITE_Y,y
        lda     _smux_event_x_msb,x
        beq     clear_x_msb
        lda     VIC_SPRITE_X_MSB
        ora     current_bit
        bra     store_x_msb
clear_x_msb:
        lda     current_bit
        eor     #$ff
        and     VIC_SPRITE_X_MSB
store_x_msb:
        sta     VIC_SPRITE_X_MSB
        bra     event_done

enable_event:
        lda     _smux_event_x,x
        sta     VIC_SPRITE_ENABLE

event_done:
        lda     _smux_debug_enabled
        beq     no_debug
        inc     VIC_BORDER
no_debug:
        inc     _smux_irq_event
        ldx     _smux_front
        lda     _smux_irq_event
        cmp     _smux_event_count,x
        bcs     frame_done

        jsr     load_index
        lda     _smux_event_raster,x
        cmp     VIC_RASTER
        beq     process_event
        sta     VIC_RASTER
        sec
        rts

frame_done:
        stz     _smux_irq_event
        lda     _smux_swap_pending
        beq     schedule_zero
        lda     _smux_front
        eor     #$01
        sta     _smux_front
        stz     _smux_swap_pending
schedule_zero:
        stz     VIC_RASTER
        sec
        rts

; X = front * 64 + event.
load_index:
        lda     _smux_front
        asl     a
        asl     a
        asl     a
        asl     a
        asl     a
        asl     a
        clc
        adc     _smux_irq_event
        tax
        rts

        .segment        "RODATA"
sprite_bit:
        .byte   $01,$02,$04,$08,$10,$20,$40,$80

        .segment        "BSS"
current_bit: .res 1

        .segment        "LOWCODE"
irq_stub:
        cld
        jsr     callirq
saved_irq_jump:
        jmp     $0000
