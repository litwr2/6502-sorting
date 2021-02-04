;for vasm assembler, madmac syntax

;#define sz SIZE
;#define type TYPE
;#define tabsz 12
;#define swap(x,y) {type t = x; x = y; y = t;}
;type data[sz];
;unsigned short gap2table[tabsz] = {2, 8, 20, 46, 114, 264, 602, 1402, 3500, 4759*2, 12923*2, 30001*2};
;void shell() {
;    type *j2, *i2, *stack;
;    unsigned short gap2;
;    unsigned char x = tabsz;
;lss1:
;    if (x == 0) return;
;    j2 = data;
;    gap2 = gap2table[x - 1]/2;
;    i2 = data + gap2;
;lss3:
;    if (i2 == data + sz) {
;       x--;
;       goto lss1;
;    }
;    stack = j2;
;lss8:
;    if (*i2 < *j2) {
;        swap(*j2, *i2);
;        i2 = j2;
;        if (j2 - gap2 >= data) {
;            j2 -= gap2;
;            goto lss8;
;        }
;    }
;    j2 = stack + 1;
;    i2 = j2 + gap2;
;    goto lss3;
;}

shellsort:     ;it is sligtly faster if it has page offset about 0 - $30
.j2lo   = 12   ;zero page locations, select any available on your system
.j2hi   = .j2lo+1
.i2lo   = 14
.i2hi   = .i2lo+1
          sty .sz2hi+1
          stx .sz2lo+1
          ldy addrhi
          sty .lss10+1
          sty .datahi2+1
          ldy addrlo
          sty .datalo1+1
          sty .datalo2+1
          ldy #0
          tax
.lss1:    stx .lssm+1
          bne .lss10
          rts

.lss10:   lda #0
          sta .j2hi
.datalo1: lda #0
          sta .j2lo
          lda .gaptable-2,x
          sta .gap2lo+1
          clc
          adc .j2lo
          sta .i2lo
          lda .gaptable-1,x
          sta .gap2hi+1
          adc .j2hi
          sta .i2hi
.lss3:    ;lda .i2hi
.sz2hi:   cmp #0
          bcc .lss2  ;if shelltabidx links with a gap which is less than sz
          bne .lssm  ;then it is possible to use just 'bne .lss2' here

          lda .i2lo
.sz2lo:   cmp #0
          bcc .lss2  ;and 'bne .lss2' here

.lssm:    ldx #0
          dex
          dex
          bpl .lss1   ;=jmp

.lss2:    lda .j2hi
          sta .lssm1+1
          lda .j2lo
          sta .lss5+1
.lss8:    lda (.i2lo),y
          cmp (.j2lo),y
      if ESZ==2
          iny
          lda (.i2lo),y
          sbc (.j2lo),y
          dey
      endif
          bcs .lss5

.lss6:    lda (.j2lo),y
          tax
          lda (.i2lo),y
          sta (.j2lo),y
          txa
          sta (.i2lo),y
      if ESZ==2
          iny
          lda (.j2lo),y
          tax
          lda (.i2lo),y
          sta (.j2lo),y
          txa
          sta (.i2lo),y
          dey
      endif

          sec
          lda .j2lo
          sta .i2lo
.gap2lo:  sbc #0
          sta .j2lo
          lda .j2hi
          sta .i2hi
.gap2hi:  sbc #0
          bcc .lss5

          sta .j2hi
          lda .j2lo
.datalo2: cmp #<0
          lda .j2hi
.datahi2: sbc #>0
          bcs .lss8

.lss5:    lda #0
          clc
          adc #ESZ
          sta .j2lo
.lssm1:   lda #0
          adc #0
          sta .j2hi

          lda .j2lo
          adc .gap2lo+1
          sta .i2lo
          lda .j2hi
          adc .gap2hi+1
          sta .i2hi
          jmp .lss3

.gaptable: dc.w 1*ESZ, 4*ESZ, 10*ESZ, 23*ESZ, 57*ESZ, 132*ESZ, 301*ESZ, 701*ESZ, 1750*ESZ, 4759*ESZ, 12923*ESZ
;    if ESZ==1
;     dc.w 33001*ESZ
;    endif


