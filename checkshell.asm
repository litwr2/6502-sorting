shelltabidx2 = 22
addrhi = 10
addrlo = 11

ESZ = 2
data = $400
sz = 30000
sz2 = sz*ESZ

        org $200
        lda #<data
        sta addrlo
        lda #>data
        sta addrhi
        ldx #<(data+sz2)
        ldy #>(data+sz2)
        lda #shelltabidx2  ;may be less
        jsr shellsort
        brk               ;stop here

        org $300
        include "shell.s"
