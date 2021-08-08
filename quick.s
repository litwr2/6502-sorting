;for vasm assembler, oldstyle syntax
stacklvl = 26   ;stacklvl*6+stackint is amount of free stack space required for successful work of this routine
stackint = 12   ;stack space reserved for irq and nmi

;#include <setjmp.h>
;#define sz 30000
;#define splimit 20
;#define type unsigned short
;#define ssz 200
;#define swap(x,y) {type t = x; x = y; y = t;}
;jmp_buf jmp_point;
;type *sa[ssz], **sp;
;void push(type *d) {
;    *sp-- = d;
;}
;type* pop() {
;    return *++sp;
;}
;type data[sz];
;type x, *ub, *lb, *i2, *j2;
;void quick0() {
;    sp--;
;    if (sp - sa < splimit) longjmp(jmp_point, 1);
;    i2 = lb;
;    j2 = ub;
;    x = *(type*)(((unsigned long)j2 + (unsigned long)i2) >> 1 & ~(sizeof(type) - 1));
;qsloop1:
;    if (*i2 >= x) goto qs_l1;
;    i2 += 1;
;    goto qsloop1;
;qs_l1:
;    if (x >= *j2) goto qs_l3;
;    j2 -= 1;
;    goto qs_l1;
;qs_l3:
;    if (j2 < i2) goto qs_l8;
;    if (j2 != i2) swap(*i2, *j2);
;    i2 += 1;
;    j2 -= 1;
;    if (j2 >= i2) goto qsloop1;
;qs_l8:
;    if (lb >= j2) goto qs_l5;
;    push(i2);
;    push(ub);
;    ub = j2;
;    quick0();
;    ub = pop();
;    i2 = pop();
;qs_l5:
;    if (i2 >= ub) goto quit;
;    lb = i2;
;    quick0();
;quit:
;    sp++;
;}
;void quick() {
;    type *gub = ub, *glb = lb;
;    setjmp(jmp_point);
;    sp = sa + ssz - 1;
;    ub = gub;
;    lb = glb;
;    quick0();
;}

quicksort:    ;it is sligtly faster if it has page offset about $90 - $d0
.i2lo = zp1
.i2hi = .i2lo+1
.j2lo = zp2
.j2hi = .j2lo+1
           sta .datahi+1
           lda param
           sta .datalo+1
      if ODD_OFFSET
           and #1
           sta .evenness+1
      endif
           stx .szlo+1
           sty .szhi+1
           tsx
           stx .qs_csp+1
           txa
           sec
           sbc #stacklvl*6
           bcs *+3
           rts        ;error: quicksort may meditate, C=0 - error

           sta .stacklim+1
           cmp #stackint   ;this check may be skipped if irq are disabled and nmi are impossible
           bcs *+3
           rts        ;error: irq may get not enough space, C=0 - error

.qs_csp:   ldx #0
           txs
.szhi:     lda #>0
           sta .ubhi+1
.szlo:     lda #<0
           sta .ublo+1
.datalo:   ldy #<0
           sty .lblo+1
.datahi:   lda #>0
           sta .lbhi+1
.quicksort0:
           tsx
.stacklim: cpx #0
           bcc .qs_csp

           ;ldy .lblo+1
           sty .i2lo
           ;lda .lbhi+1
           sta .i2hi
           ldy .ubhi+1
           sty .j2hi
           lda .ublo+1
           sta .j2lo
           clc
           adc .i2lo
       if ESZ=2
           and #$fc
       endif
           tax
           tya
           adc .i2hi
           ror
           sta .axlo+2
       if ESZ==2
           sta .axhi+2
       endif
           txa
           ror
       if ODD_OFFSET
.evenness:ora #0
       endif
           sta .axlo+1
       if ESZ==2
           sta .axhi+1
       endif
.axlo:     lda $1000
           sta .x_lo+1
       if ESZ==2
           ldx #1
.axhi:     lda $1000,x
           sta .x_hi+1
       endif
.qsloop1:  ldy #0     ;compare array[i] and x
           lda (.i2lo),y
.x_lo:     cmp #0
      if ESZ==2
           iny
           lda (.i2lo),y
           sbc .x_hi+1
      endif
           bcs .qs_l1

           lda #ESZ
           adc .i2lo
           sta .i2lo
           bcc .qsloop1

           inc .i2hi
           bne .qsloop1 ;=jmp

.qs_l1:    ldy #0    ;compare array[j] and x
           lda .x_lo+1
           cmp (.j2lo),y
      if ESZ==2
           iny
.x_hi:     lda #0
           sbc (.j2lo),y
      endif
           bcs .qs_l3

           lda .j2lo
           sbc #ESZ-1
           sta .j2lo
           bcs .qs_l1

           dec .j2hi
           bne .qs_l1 ;=jmp

.qs_l3:    lda .j2hi    ;compare i and j
           cmp .i2hi
           bcc .qs_l8
           bne .qsloop2

           lda .j2lo
           cmp .i2lo
           bcc .qs_l8
           beq .qs_l9

.qsloop2:  lda (.j2lo),y    ;exchange elements with i and j indices
           tax
           lda (.i2lo),y
           sta (.j2lo),y
           txa
           sta (.i2lo),y
      if ESZ==2
           dey
           bpl .qsloop2
      endif

.qs_l9:    lda #ESZ-1        ;CY=1
           adc .i2lo
           sta .i2lo
           bcc *+4
           inc .i2hi
           sec
           lda .j2lo
           sbc #ESZ
           sta .j2lo
           bcs *+4
           dec .j2hi
           ;lda j2lo
           cmp .i2lo
           lda .j2hi
           sbc .i2hi
           bcs .qsloop1

.qs_l8:
.lblo:     ldy #0
           cpy .j2lo
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
           lda .lbhi+1
           jsr .quicksort0
           pla
           sta .ublo+1
           pla
           sta .ubhi+1
           pla
           sta .i2lo
           pla
           sta .i2hi
.qs_l5:    ldy .i2lo
.ublo:     cpy #0
           lda .i2hi
.ubhi:     sbc #0
           bcs .qs_l7

           lda .i2hi
           sta .lbhi+1
           sty .lblo+1
           jsr .quicksort0   ;don't use the tail call optimization! it can be much slower for some data
.qs_l7:    rts       ;C=1 - ok

