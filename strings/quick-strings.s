;for vasm assembler, oldstyle syntax
;a safe quicksort implementation, insertionsort optimization is used
;version 2
;if there is no enough stack space it switches to insertionsort
stacklvl = 20   ;stacklvl*6+stackint is amount of free stack space required for successful work of this routine
                ;stacklvl must be greater than or equal to mindepth
stackint = 10   ;stack space reserved for irq and nmi
insert_lim = 10 ;when switch to insertionsort

quicksort:    ;it is sligtly faster if it has page offset about $90 - other optimal values are possible, seek them
       ;y/x - high/low of array size-1, a/param - low/high byte of the start of the array
.i2lo = zp1
.i2hi = .i2lo+1
.j2lo = zp2
.j2hi = .j2lo+1
.xlo = zp3
.xhi = .xlo+1

           sta .datahi+1
           stx .szlo+1
           sty .szhi+1
           tax
           lda param
           sta .datalo+1
           sec
.loop255:  sbc #255
           tay
           txa
           sbc #0
           tax
           tya
           bcs .loop255

           adc #3
           bcc *-2

           sta .tval+1
           eor #3
           asl
           sta .corr32+1
           jsr .setb      ;for insertionsort
           lda #4
.tval:     sbc #0     ;CY=0
           sta .corr31+1
           tsx
           stx .qs_csp+1
           txa
           sec
           sbc #stacklvl*6+stackint
           bcs .qs_ok

           adc #(stacklvl-mindepth)*6
           bcc .insjmp

.qs_ok:    adc #stackint-1  ;C=1
           sta .stacklim+1
.qs_csp:   ldx #0
           txs
           jsr .setb
.quicksort0:
           tsx
.stacklim: cpx #0
           bcc .qs_csp

           ;lda .ublo+1
           sbc .lblo+1    ;CY=1
           tax
           lda .ubhi+1
           sbc .lbhi+1
           bne .quick

           txa
           cmp #insert_lim*2
           bcs .quick
.insjmp:   jmp .insertion

.quick:    lda .lblo+1
           sta .i2lo
           lda .lbhi+1
           sta .i2hi
           ldy .ubhi+1
           sty .j2hi
           lda .ublo+1
           sta .j2lo
           clc
           adc .i2lo
           tax
           tya
           adc .i2hi
           tay
           txa
.corr32:   adc #0
           tax
           tya
           adc #0
           ror
           tay
.adj3:     txa
           ror
           bcc .adj3ok

           sbc #1   ;CY=1
           bcs .adj3ok

           dey
.adj3ok:   sec
.corr31:   sbc #0
           sta .xlo
           bcs *+3
           dey
           sty .xhi
           ldy #0
           lda (.xlo),y
           sta .xlen+1
           iny
           lda (.xlo),y
           sta .xstr1+1
           sta .xstr2+1
           iny
           lda (.xlo),y
           sta .xstr1+2
           sta .xstr2+2
.qsloop1:  ldy #0     ;compare array[i] and x
           lda (.i2lo),y
           sta .tmp1_len+1
           iny
           lda (.i2lo),y
           sta .tmp1+1
           iny
           lda (.i2lo),y
           sta .tmp1+2
           ldy #$ff
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
.l2a:      lda #2
           adc .i2lo   ;CY=1
           sta .i2lo
           bcc .qsloop1

           inc .i2hi
           bne .qsloop1 ;=jmp

.qs_l1:    ldy #0    ;compare array[j] and x
           lda (.j2lo),y
           sta .tmp2_len+1
           iny
           lda (.j2lo),y
           sta .tmp2+1
           iny
           lda (.j2lo),y
           sta .tmp2+2
           ldy #$ff
.l1b:      iny
.tmp2_len: cpy #0
           bcs .qs_l3

           cpy .xlen+1
           bcs .l2b

.xstr2:    lda $1000,y
.tmp2:     cmp $1000,y
           beq .l1b
           bcs .qs_l3

           sec
.l2b:      lda .j2lo
           sbc #3     ;CY=1
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

.l1:       jsr .xchg
.qs_l9:    lda #2        ;CY=1
           adc .i2lo
           sta .i2lo
           bcc *+5
           inc .i2hi
           clc
           lda .j2lo
           sbc #2       ;CY=0
           sta .j2lo
           bcs *+4
           dec .j2hi
           ;lda j2lo
           cmp .i2lo
           lda .j2hi
           sbc .i2hi
           bcc .lblo
           jmp .qsloop1  ;bcs?

.lblo:     lda #0
           cmp .j2lo
.lbhi:     lda #0
           sbc .j2hi
           bcs .qs_l5

           lda .i2hi
           pha
           lda .i2lo
           pha
           lda .ubhi+1
           pha
           lda .ublo+1
           pha
           lda .j2hi
           sta .ubhi+1
           lda .j2lo
           sta .ublo+1
           jsr .quicksort0
           pla
           sta .ublo+1
           pla
           sta .ubhi+1
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
           sta .lbhi+1
           stx .lblo+1
           lda .ublo+1
           jsr .quicksort0   ;don't use the tail call optimization! it can be much slower for some data
.qs_l7:    rts       ;C=1 - ok

.setb:     
.szhi:     lda #>0
           sta .ubhi+1
.datahi:   lda #>0
           sta .lbhi+1
.datalo:   lda #<0
           sta .lblo+1
.szlo:     lda #<0
           sta .ublo+1
           rts

.insertion:
.k2lo = .i2lo
.k2hi = .k2lo+1

            clc
            lda .ublo+1
            adc #3
            sta .iszlo+1
            lda .ubhi+1
            adc #0
            sta .iszhi+1
            lda .lbhi+1
            sta .idatahi+1
            sta .ii2hi+1
            lda .lblo+1
            sta .idatalo+1
            adc #3     ;CY=0
            bcc .ll1

            inc .ii2hi+1
.ll1:       sta .ii2lo+1
            sta .j2lo
.iszlo:     cmp #0
.ii2hi:     lda #0
            sta .j2hi
.iszhi:     sbc #0
            bcc *+3
            rts    ;C=1 - ok

.ll3:       lda .j2hi
            sta .k2hi
            sec
            lda .j2lo
            sbc #3
            sta .k2lo
            bcs *+4

            dec .k2hi
            lda .j2lo
.idatalo:   cmp #0
            bne .l3

            lda .j2hi
.idatahi:   cmp #0
            beq .ii2lo

.l3:        ldy #0
            lda (.j2lo),y
            sta .jlen+1
            lda (.k2lo),y
            sta .klen+1
            iny
            lda (.j2lo),y
            sta .tmp4+1
            lda (.k2lo),y
            sta .tmp3+1
            iny
            lda (.j2lo),y
            sta .tmp4+2
            lda (.k2lo),y
            sta .tmp3+2
            ldy #$ff
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
            adc #2   ;CY=1
            bcc .ll1

            inc .ii2hi+1
            bne .ll1      ;always

.cont1:     sec
.cont2:     jsr .xchg
            lda .j2lo
            sbc #3   ;CY=1
            sta .j2lo
            bcs .ll3

            dec .j2hi
            bne .ll3     ;always

.xchg:      ldy #2
.loop:      lda (.j2lo),y
            tax
            lda (.k2lo),y
            sta (.j2lo),y
            txa
            sta (.k2lo),y
            dey
            bpl .loop
            rts

