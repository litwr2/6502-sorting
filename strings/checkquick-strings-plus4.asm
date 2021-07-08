;for vasm assembler, oldstyle syntax
;This code depends on the Commodore/Plus4 architecture
;version 2
;$47,$48 - start of arrays

param = $47
zp1 = $d0   ;+$d1  ;zero page locations, select any available on your system
zp2 = $d2   ;+$d3
zp3 = $d4   ;+$d5
mindepth = 14      ;no more than 16384 strings

     org $1001  ;c+4
     byte $b,$10,$a,0,$9e,"4109",0,0,0

     ;org $100d
init:   jmp init0

irq:    dec $7fd
        bpl intsc

        pha
        lda #4
        sta $7fd
        pla
        jsr uptime
intsc:  jsr uptime
        inc $ff09
        rti

uptime: inc $a5
        bne .l1

        inc $a4
        bne .l1

        inc $a3
.l1:    rts

start:  JSR $9491   ;c+4 - skip comma
        JSR $9DE1   ;c+4 - evaluate expression to $14,$15
        JSR $9491   ;c+4 - skip comma
        JSR $932c   ;c+4 - get string address in $47,$48
        sei
        sta $ff3f
        lda #>irq
        sta $ffff
        lda #<irq
        sta $fffe
        cli
        clc
        lda $47     ;start of array
        adc $14     ;array length
        tax
        lda $48
        adc $15
        tay
        txa
        adc $14
        tax
        tya
        adc $15
        tay
        txa
        adc $14
        tax
        tya
        adc $15
        tay
        txa
        sbc #2  ;CY=0
        tax
        tya
        sbc #0
        tay
        lda $48
        jsr quicksort
.loop:  ldy #0            ;fix gc data
        lda ($47),y
        beq .cont

        iny
        clc
        adc ($47),y
        sta zp1
        iny
        lda #0
        adc ($47),y
        sta zp1+1
        lda $48
        dey
        sta (zp1),y
        dey
        lda $47
        sta (zp1),y
.cont:  lda $47
        adc #3
        sta $47
        bcc *+4
        inc $48
        lda quicksort.szlo+1
        cmp $47
        lda quicksort.szhi+1
        sbc $48
        bcs .loop

        sta $ff3e
        rts

     ;org $10c0  ;it may be commented to get the most compact code
;The next code is architecture independent
     include "quick-strings.s"

;The C+4 startup code
init0: lda #>(init0+1)
        sta $2c
        sta $2e
        sta $30
        sta $32
       lda #<init0+1
        sta $2b
        sta $2d
        sta $2f
        sta $31
        lda #0
        sta init0
        sta init0+1
        sta init0+2
        rts

