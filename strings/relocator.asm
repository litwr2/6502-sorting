;zp locations
zp1 = $70   ;+$71
zp2 = $72   ;+$73
zp3 = $74   ;+$75

     org $200
        lda $444  ;lo(q%)
        sta zp2
        sta zp3
        lda $445  ;hi(q%)
        sta zp2+1
        sec
        sbc #2
        sta zp3+1
        lda $424   ;lo(i%)
        adc #<data-1   ;CY=1
        sta zp1
        lda $425   ;hi(i%)
        adc #>(data-$200)
        sta zp1+1
        ldx #0
loop:   txa
        tay
        lda (zp1),y
        cmp #$ff
        beq exit

        adc zp2
        sta zp2
        bcc *+4
        inc zp2+1
        ldy #0
        clc
        lda (zp2),y
        adc zp3
        sta (zp2),y
        iny
        lda (zp2),y
        adc zp3+1
        sta (zp2),y
        inx
        bne loop
exit:   rts
data:
        include "reloc-data.s"