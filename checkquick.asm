param = 10   ;a zp location for parameter

ESZ = 2      ;an element size
data = $400  ;sorted array must start here
sz = 30000   ;number of elements in the array
sz2 = sz*ESZ

     org $200
        lda #<data
        sta param
        lda #>data
        ldx #<(data+sz2-ESZ)
        ldy #>(data+sz2-ESZ)
        jsr quicksort     ;C=0 means fail
        brk               ;stop here

     org $2d0
     include "quick.s"

