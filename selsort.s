;for vasm assembler, oldstyle syntax

;#define sz SIZE
;#define type TYPE
;#define swap(x,y) {type t = x; x = y; y = t;}
;type data[sz];
;void selection() {
;    type *i = data, *k, *min;
;l7: min = i;
;    k = i + 1;
;l3: if (k == data + sz) goto l8;
;    if (*k >= *min) goto l4;
;    min = k;
;l4: k++;
;    goto l3;
;l8: //if (min != i)
;    swap(*min, *i);
;    i++;
;    if (i != k) goto l7;
;}

selsort:    ;it is sligtly faster if it has page offset about 0 - $80
.i2lo = 10  ;zero page locations, select any available on your system
.i2hi = .i2lo+1
.k2lo = 12
.k2hi = .k2lo+1
.minlo = 14
.minhi = .minlo+1
          stx .sz2lo+1
          sty .sz2hi+1
          sta .i2hi
          lda param
          sta .i2lo
.ll7:     ;lda i2lo
          sta .minlo
          clc
          adc #ESZ
          sta .k2lo
          lda .i2hi
          sta .minhi
          adc #0
          sta .k2hi
.ll3:     ;lda .k2hi
.sz2hi:   cmp #>0
          bne .no8

.sz2lo:   lda #0
          cmp .k2lo
          beq .ll8

.no8:     ldy #0
          lda (.k2lo),y
          cmp (.minlo),y
     if ESZ==2
          iny
          lda (.k2lo),y
          sbc (.minlo),y
     endif
          bcs .ll4

          lda .k2lo
          sta .minlo
          lda .k2hi
          sta .minhi
.ll4:     clc
          lda .k2lo
          adc #ESZ
          sta .k2lo
          lda .k2hi
          adc #0
          sta .k2hi
          bcc .ll3    ;jmp

.ll8:     ldy #ESZ-1
.loop:    lda (.i2lo),y
          tax
          lda (.minlo),y
          sta (.i2lo),y
          txa
          sta (.minlo),y
     if ESZ==2
          dey
          bpl .loop
     endif

          lda .i2lo
          adc #ESZ-1   ;CY=1
          sta .i2lo
          lda .i2hi
          adc #0
          sta .i2hi

          lda .i2lo
          cmp .k2lo
          bne .ll7

          ldx .i2hi
          cpx .k2hi
          bne .ll7
          rts

