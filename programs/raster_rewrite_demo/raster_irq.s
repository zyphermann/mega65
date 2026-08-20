; Sorted, double-buffered VIC-IV sprite position rewrite queue.

        .setcpu         "65C02"

        .import         _rewrite_count
        .import         _rewrite_debug_enabled
        .import         _rewrite_event
        .import         _rewrite_front
        .import         _rewrite_swap_pending
        .import         _rewrite_raster
        .import         _rewrite_raster_msb
        .import         _rewrite_slot
        .import         _rewrite_x
        .import         _rewrite_x_msb
        .import         _rewrite_y
        .import         callirq

        .export         initirq
        .export         doneirq

        .interruptor    raster_rewrite_irq, 30

MAX_EVENTS        = 16
VIC_SPRITE_X      = $d000
VIC_SPRITE_Y      = $d001
VIC_SPRITE_X_MSB  = $d010
VIC_CTRL1         = $d011
VIC_RASTER        = $d012
VIC_IRQ_STATUS    = $d019
VIC_BACKGROUND    = $d021
KERNAL_IRQ_VECTOR = $0314

        .segment        "ONCE"

; The current cc65 MEGA65 library contains callirq but no platform IRQ-vector
; bridge. Install the same reversible $0314 bridge used by its C64 runtime.
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

raster_rewrite_irq:
        lda     VIC_IRQ_STATUS
        and     #$01
        bne     is_raster_irq
        jmp     not_handled

is_raster_irq:
        lda     #$01                    ; Acknowledge raster IRQ.
        sta     VIC_IRQ_STATUS

        jsr     load_event_index
        lda     _rewrite_raster,x
        sta     irq_raster_line
        lda     _rewrite_raster_msb,x
        sta     irq_raster_msb

        lda     _rewrite_debug_enabled
        beq     process_event
        lda     _rewrite_event
        and     #$03
        tay
        lda     debug_color,y
        sta     VIC_BACKGROUND

process_event:
        ; Y becomes the VIC position-register offset (slot * 2).
        ldy     _rewrite_slot,x
        lda     sprite_bit,y
        sta     irq_sprite_bit
        tya
        asl     a
        tay

        lda     _rewrite_x,x
        sta     VIC_SPRITE_X,y
        lda     _rewrite_y,x
        sta     VIC_SPRITE_Y,y

        lda     _rewrite_x_msb,x
        beq     clear_x_msb
        lda     VIC_SPRITE_X_MSB
        ora     irq_sprite_bit
        bne     store_x_msb

clear_x_msb:
        lda     irq_sprite_bit
        eor     #$ff
        and     VIC_SPRITE_X_MSB

store_x_msb:
        sta     VIC_SPRITE_X_MSB

        inc     _rewrite_event
        ldx     _rewrite_front
        lda     _rewrite_event
        cmp     _rewrite_count,x
        bcc     more_events

        ; Publish a complete backbuffer only after the final raster group.
        stz     _rewrite_event
        lda     _rewrite_swap_pending
        beq     schedule_next
        lda     _rewrite_front
        eor     #$01
        sta     _rewrite_front
        stz     _rewrite_swap_pending
        bra     schedule_next

more_events:
        jsr     load_event_index
        lda     _rewrite_raster,x
        cmp     irq_raster_line
        bne     schedule_next
        lda     _rewrite_raster_msb,x
        cmp     irq_raster_msb
        beq     process_event            ; Same-line events share one IRQ.

schedule_next:
        jsr     load_event_index
        lda     VIC_CTRL1
        and     #$7f
        ldy     _rewrite_raster_msb,x
        beq     store_raster_msb
        ora     #$80
store_raster_msb:
        sta     VIC_CTRL1
        lda     _rewrite_raster,x
        sta     VIC_RASTER
        sec
        rts

; X = front * MAX_EVENTS + event. MAX_EVENTS is deliberately a power of two.
load_event_index:
        lda     _rewrite_front
        asl     a
        asl     a
        asl     a
        asl     a
        clc
        adc     _rewrite_event
        tax
        rts

not_handled:
        clc
        rts

        .segment        "RODATA"

sprite_bit:
        .byte   $01, $02, $04, $08, $10, $20, $40, $80
debug_color:
        .byte   $f0, $f1, $f2, $f3

        .segment        "BSS"

irq_raster_line: .res 1
irq_raster_msb:  .res 1
irq_sprite_bit:  .res 1

        .segment        "LOWCODE"

irq_stub:
        cld
        jsr     callirq
saved_irq_jump:
        jmp     $0000
