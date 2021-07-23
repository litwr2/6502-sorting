;for vasm assembler, oldstyle syntax
;a safe quicksort implementation, insertionsort optimization is used
;version 1
;if there is no enough stack space it switches to insertionsort
stacklvl = 20   ;stacklvl*6+stackint is amount of free stack space required for successful work of this routine
                ;stacklvl must be greater than or equal to mindepth
stackint = 10   ;stack space reserved for irq and nmi
insert_lim = 10 ;when switch to insertionsort

quicksort:    ;it is sligtly faster if it has page offset about $90 - other optimal values are possible, seek them
    ;y/x - high/low of array size-1, a/param - high/low byte of the start of the array
.i2lo = zp1
.i2hi = .i2lo+1
.j2lo = zp2
.j2hi = .j2lo+1
.xlo = zp3
.xhi = .xlo+1

           sta .datahi+1     ;##+1=2
           stx .szlo+1       ;##+1=2
           sty .szhi+1       ;##+1=2
           lda param
           sta .datalo+1     ;##+1=2
           and #3
           sta .corr32+1     ;##+1=2
           jsr .setb      ;for insertionsort  ;##+1=2
           tsx
           stx .qs_csp+1     ;##+1=2
           txa
           sec    ;?optimize
           sbc #stacklvl*6+stackint
           bcs .qs_ok

           adc #(stacklvl-mindepth)*6
           bcc .insjmp

.qs_ok:    adc #stackint-1  ;CY=1
           sta .stacklim+1   ;##+1=2
.qs_csp:   ldx #0
           txs
           jsr .setb         ;##+1=2
.quicksort0:
           tsx
.stacklim: cpx #0
           bcc .qs_csp

           ;lda .ublo+1
           sbc .lblo+1    ;CY=1  ;;##+1=2
           tax
           lda .ubhi+1    ;##+1=2
           sbc .lbhi+1    ;##+1=2
           bne .quick

           txa
           cmp #insert_lim*2
           bcs .quick
.insjmp:   jmp .insertion   ;##+1=2

.quick:    lda .lblo+1    ;##+1=2
           sta .i2lo
           lda .lbhi+1    ;##+1=2
           sta .i2hi
           ldy .ubhi+1    ;##+1=2
           sty .j2hi
           lda .ublo+1    ;##+1=2
           sta .j2lo
           clc
           adc .i2lo
           tax
           tya
           adc .i2hi
           ror
           tay
           txa
           ror
           and #$fc
.corr32:   adc #0   ;CY=0
           sta .xlo
           sty .xhi
           ldy #3
           lda (.xlo),y
           sta .xlen+1     ;##+1=2
           ldy #1
           lda (.xlo),y
           sta .xstr1+2    ;##+1=2
           sta .xstr2+2    ;##+1=2
           dey
           lda (.xlo),y
           sta .xstr1+1    ;##+1=2
           sta .xstr2+1    ;##+1=2
.qsloop1:  ldy #3     ;compare array[i] and x
           lda (.i2lo),y
           sta .tmp1_len+1 ;##+1=2
           ldy #1
           lda (.i2lo),y
           sta .tmp1+2     ;##+1=2
           dey
           lda (.i2lo),y
           sta .tmp1+1     ;##+1=2
           dey  ;y = $ff
.l1a:      iny
.xlen:     cpy #0
           bcs .qs_l1

.tmp1_len: cpy #0
           bcs .l2a

.tmp1:     lda $1000,y
.xstr1:    cmp $1000,y
           beq .l1a
           bcs .qs_l1

           sec
.l2a:      lda #3
           adc .i2lo   ;CY=1
           sta .i2lo
           bcc .qsloop1

           inc .i2hi
           bne .qsloop1 ;=jmp

.qs_l1:    ldy #3    ;compare array[j] and x
           lda (.j2lo),y
           sta .tmp2_len+1   ;##+1=2
           ldy #1
           lda (.j2lo),y
           sta .tmp2+2       ;##+1=2
           dey
           lda (.j2lo),y
           sta .tmp2+1       ;##+1=2
           dey
.l1b:      iny
.tmp2_len: cpy #0
           bcs .qs_l3

           cpy .xlen+1       ;##+1=2
           bcs .l2b

.xstr2:    lda $1000,y
.tmp2:     cmp $1000,y
           beq .l1b
           bcs .qs_l3

           sec
.l2b:      lda .j2lo
           sbc #4     ;CY=1
           sta .j2lo
           bcs .qs_l1

           dec .j2hi
           bne .qs_l1 ;=jmp

.qs_l3:    lda .j2hi    ;compare i and j
           cmp .i2hi
           bcc .lblo
           bne .l1

           lda .j2lo
           cmp .i2lo
           bcc .lblo
           beq .qs_l9

.l1:       jsr .xchg    ;##+1=2
.qs_l9:    lda #3        ;CY=1
           adc .i2lo
           sta .i2lo
           bcc *+5
           inc .i2hi
           clc
           lda .j2lo
           sbc #3       ;CY=0
           sta .j2lo
           bcs *+4
           dec .j2hi
           ;lda j2lo
           cmp .i2lo
           lda .j2hi
           sbc .i2hi
           bcc .lblo
           jmp .qsloop1  ;bcs?   ;##+1=2

.lblo:     lda #0
           cmp .j2lo
.lbhi:     lda #0
           sbc .j2hi
           bcs .qs_l5

           lda .i2hi
           pha
           lda .i2lo
           pha
           lda .ubhi+1   ;##+1=2
           pha
           lda .ublo+1   ;##+1=2
           pha
           lda .j2hi
           sta .ubhi+1   ;##+1=2
           lda .j2lo
           sta .ublo+1   ;##+1=2
           jsr .quicksort0   ;##+1=2
           pla
           sta .ublo+1   ;##+1=2
           pla
           sta .ubhi+1   ;##+1=2
           pla
           sta .i2lo
           pla
           sta .i2hi
.qs_l5:    ldx .i2lo
.ublo:     cpx #0
           lda .i2hi
.ubhi:     sbc #0
           bcs .qs_l7

           lda .i2hi
           sta .lbhi+1    ;##+1=2
           stx .lblo+1    ;##+1=2
           lda .ublo+1    ;##+1=2
           jsr .quicksort0   ;don't use the tail call optimization! it can be much slower for some data ;##+1=2
.qs_l7:    rts       ;C=1 - ok

.setb:     
.szhi:     lda #>0
           sta .ubhi+1   ;##+1=2
.datahi:   lda #>0
           sta .lbhi+1   ;##+1=2
.datalo:   lda #<0
           sta .lblo+1   ;##+1=2
.szlo:     lda #<0
           sta .ublo+1   ;##+1=2
           rts

.insertion:
.k2lo = .i2lo
.k2hi = .k2lo+1

            clc
            lda .ublo+1   ;##+1=2
            adc #4
            sta .iszlo+1  ;##+1=2
            lda .ubhi+1   ;##+1=2
            adc #0
            sta .iszhi+1  ;##+1=2
            lda .lbhi+1   ;##+1=2
            sta .idatahi+1  ;##+1=2
            sta .ii2hi+1   ;##+1=2
            lda .lblo+1   ;##+1=2
            sta .idatalo+1   ;##+1=2
            adc #4     ;CY=0
            bcc .ll1

            inc .ii2hi+1   ;##+1=2
.ll1:       sta .ii2lo+1   ;##+1=2
            sta .j2lo
.iszlo:     cmp #0
.ii2hi:     lda #0
            sta .j2hi
.iszhi:     sbc #0
            bcc *+3
            rts

.ll3:       lda .j2hi
            sta .k2hi
            sec
            lda .j2lo
            sbc #4
            sta .k2lo
            bcs *+4

            dec .k2hi
            lda .j2lo
.idatalo:   cmp #0
            bne .l3

            lda .j2hi
.idatahi:   cmp #0
            beq .ii2lo

.l3:        ldy #3
            lda (.j2lo),y
            sta .jlen+1     ;##+1=2
            lda (.k2lo),y
            sta .klen+1     ;##+1=2
            ldy #1
            lda (.j2lo),y
            sta .tmp4+2     ;##+1=2
            lda (.k2lo),y
            sta .tmp3+2     ;##+1=2
            dey
            lda (.j2lo),y
            sta .tmp4+1     ;##+1=2
            lda (.k2lo),y
            sta .tmp3+1     ;##+1=2
            dey
.l1c:       iny
.klen:      cpy #0
            bcs .ii2lo

.jlen:      cpy #0
            bcs .cont2

.tmp4:     lda $1000,y
.tmp3:     cmp $1000,y
           bcc .cont1
           beq .l1c

.ii2lo:     lda #0
            adc #3   ;CY=1
            bcc .ll1

            inc .ii2hi+1    ;##+1=2
            bne .ll1      ;always

.cont1:     sec
.cont2:     jsr .xchg   ;##+1=2
            lda .j2lo
            sbc #4   ;CY=1
            sta .j2lo
            bcs .ll3

            dec .j2hi
            bne .ll3     ;always

.xchg:      ldy #3
.loop:      lda (.j2lo),y
            tax
            lda (.k2lo),y
            sta (.j2lo),y
            txa
            sta (.k2lo),y
            dey
            bpl .loop
            rts

