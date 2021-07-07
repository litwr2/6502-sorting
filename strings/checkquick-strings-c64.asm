;for vasm assembler, oldstyle syntax
;This code depends on the C64 architecture
;$47,$48 - start of arrays

param = $47
zp1 = $4e   ;+$4f  ;zero page locations, select any available on your system
zp2 = $50   ;+$51
zp3 = $fd   ;+$fe
mindepth = 14      ;no more than 16384 strings

     org $c000     ;c64
        JSR $AEFD   ;c64 - skip comma
        JSR $AD9E   ;c64 - evaluate expression
        JSR $B7F7   ;c64 - convert float ti integer in $14/$15
        JSR $AEFD   ;c64 - skip comma
        JSR $AD9E   ;c64 - evaluate expression
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
        rts

     org $c090  ;it may be commented to get the most compact code
;The next code is architecture independent
     include "quick-strings.s"

