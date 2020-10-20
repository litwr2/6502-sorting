;for vasm assembler, madmac syntax

radix8:      ;it is sligtly faster if it has page offset about 0 - $80
         stx .szlo+1
         sty .szhi+1
         sta .ahi2+1
         sta .ahi1+1
         lda param1
         sta .alo2+1
         sta .alo1+1
         ldx param2
         stx .loop1+2
         stx .clo2+2
         stx .clo3+2
         inx
         stx .chi1+2
         stx .chi2+2
         stx .chi3+2
         ldx #0
         txa
.loop1:  sta $1000,x
.chi1:   sta $1000,x
         inx
         bne .loop1

         sta .jhi+1    ;jlo = y
         tay
         sta .i+1
.loop3:  clc
         sty .y+1
.alo1:   lda #0
.y:      adc #0
         sta .adata1+1
.ahi1:   lda #0
         adc .jhi+1
         sta .adata1+2
.adata1: ldx $1000
.clo2:   inc $1000,x
         bne .cont1

.chi2:   inc $1000,x
.cont1:  iny
         bne *+5

         inc .jhi+1
.szlo:   cpy #0
         bne .loop3

         lda .jhi+1
.szhi:   cmp #0
         bne .loop3

         lda #0
         sta .jhi+1
         tay
.loop4:  lda #0
         sta .klo+1
         sta .khi+1
.loop5:  ldx .i+1
.clo3:   lda $1000,x
.klo:    cmp #0
         bne .cont2

.chi3:   lda $1000,x
.khi:    cmp #0
         beq .cont3

.cont2:  tya
         clc
.alo2:   adc #0
         sta .adata2+1
.jhi:    lda #0
.ahi2:   adc #0
         sta .adata2+2
.i:      lda #0
.adata2: sta $1000
         iny
         bne *+5

         inc .jhi+1
         inc .klo+1
         bne *+5

         inc .khi+1
         bne .loop5   ;jump always

.cont3:  inc .i+1
         bne .loop4
         rts

