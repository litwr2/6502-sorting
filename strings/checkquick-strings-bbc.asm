;for vasm assembler, oldstyle syntax
;version 1
;This code depends on the BBC Micro architecture

param = $604
zp1 = $70   ;+$71  ;zero page locations, select any available on your system
zp2 = $72   ;+$73
zp3 = $74   ;+$75
mindepth = 14      ;no more than 16384 strings

     org $200     ;BBC Micro
        lda $601
        sta zp1
        lda $602
        sta zp1+1
        ldy #1
        lda (zp1),y
        sta zp2+1
        dey
        lda (zp1),y
        asl
        rol zp2+1
        asl
        rol zp2+1
        adc $604    ;start of array, CY=0
        tax
        lda $605
        adc zp2+1
        tay
        txa
        sbc #3  ;CY=0
        tax
        bcs *+3
        dey
        lda $605

     include "quick-strings-bbc.s"

