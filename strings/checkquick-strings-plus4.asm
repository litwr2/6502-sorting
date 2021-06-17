;for vasm assembler, madmac syntax
;This code depends on the C/plus4 architecture
;$47,$48 - start of arrays

param = $47
zp1 = $d0   ;+$d1  ;zero page locations, select any available on your system
zp2 = $d2   ;+$d3
zp3 = $d4   ;+$d5

     org $1001  ;c+4
     dc.b $b,$10,$a,0,$9e,"4109",0,0,0

     ;org $100d
init:   lda #$13
        sta $2c
        sta $2e
        sta $30
        sta $32
        lda #0
        sta $1300
        sta $1301
        sta $1302
        rts

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
        jsr quicksort     ;C=0 means fail, your system does not have enough free stack memory
        sta $ff3e
        bcs *+3
        brk               ;error here
        rts

     org $1090  ;it may be commented to get the most compact code
;The next code is architecture independent
     include "quick-strings.s"

