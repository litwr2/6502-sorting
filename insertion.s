;for vasm assembler, oldstyle syntax

;#define sz SIZE
;#define type TYPE
;#define swap(x,y) {type t = x; x = y; y = t;}
;type data[sz];
;void insertion() {
;    type *i = data + 1, *j, *k;
;l1: if (i >= data + sz) return;
;    j = i;
;l3: k = j - 1;
;    if (j == data || *k <= *j) goto l2;
;    swap(*k, *j);
;    j--;
;    goto l3;
;l2: i++;
;    goto l1;
;}

insertion:    ;it is sligtly faster if it has page offset about 0 - $80
.k2lo = 10    ;zero page locations, select any available on your system
.k2hi = .k2lo+1
.j2lo = 12
.j2hi = .j2lo+1
            stx .szlo+1
            sty .szhi+1
            sta .datahi+1
            sta .i2hi+1
            lda param
            sta .datalo+1
            clc
            adc #ESZ
            bcc .ll1

            inc .i2hi+1
.ll1:       sta .i2lo+1
            sta .j2lo
.szlo:      cmp #0
.i2hi:      lda #0
            sta .j2hi
.szhi:      sbc #0
            bcc *+3
            rts

.ll3:       lda .j2hi
            sta .k2hi
            sec
            lda .j2lo
            sbc #ESZ
            sta .k2lo
            bcs *+4

            dec .k2hi
            lda .j2lo
.datalo:    cmp #0
            bne .l3

            lda .j2hi
.datahi:    cmp #0
            beq .i2lo

.l3:        ldy #0
            lda (.j2lo),y
            cmp (.k2lo),y
      if ESZ==2
            iny
            lda (.j2lo),y
            sbc (.k2lo),y
      endif
            bcs .i2lo

            ldy #ESZ-1
.loop:      lda (.j2lo),y
            tax
            lda (.k2lo),y
            sta (.j2lo),y
            txa
            sta (.k2lo),y
      if ESZ==2
            dey
            bpl .loop
      endif

            lda .j2lo
            sbc #ESZ-1   ;C=0
            sta .j2lo
            bcs .ll3

            dec .j2hi
            bne .ll3     ;Z!=0

.i2lo:      lda #0
            adc #ESZ-1   ;C=1
            bcc .ll1

            inc .i2hi+1
            bne .ll1    ;jump always

