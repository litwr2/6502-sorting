sz = 618  ;eqsort code size

;zp locations
zp1 = $70   ;+$71
zp2 = $72   ;+$73
zp3 = $74   ;+$75

     org $200
        lda $424   ;lo(i%)
        pha
        clc
        adc #<code
        sta zp1
        lda $425   ;hi(i%)
        adc #>(code-$200)
        sta zp1+1
        lda $444  ;lo(q%)
        sta zp2
        lda $445  ;hi(q%)
        sta zp2+1
        sbc #1   ;CY=0
        sta zp3+1

        ldy #0
        ldx #>sz
        lda #<sz
        sta zp3
loop0   lda (zp1),y
        sta (zp2),y
        iny
        bne loop0

        inc zp1+1
        inc zp2+1
        dex
        bne loop0

loop2   cpy zp3
        beq cont3

        lda (zp1),y
        sta (zp2),y
        iny
        bne loop2
        
cont3   lda $445  ;hi(q%)
        sta zp2+1
        lda zp2
        sta zp3
        pla       ;lo(i%)
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
code:
