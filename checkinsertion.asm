param = 10     ;a zp location for parameter

ESZ = 1        ;the element size
data = $400    ;sorted array must start here
sz = 60000      ;number of elements in the array

        org $200
        lda #<data
        sta param
        lda #>data
        ldx #<(data+sz*ESZ)
        ldy #>(data+sz*ESZ)
        jsr insertion
        brk               ;stop here

        org $300
        include "insertion.s"

