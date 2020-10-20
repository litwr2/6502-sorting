param = 10   ;a zp location for parameter

ESZ = 2      ;an element size
data = $400  ;sorted array must start here
sz = 30000   ;number of elements in the array

     org $200
        lda #<data
        sta param
        lda #>data
        ldx #<(data+sz*ESZ-ESZ)
        ldy #>(data+sz*ESZ-ESZ)
        jsr quicksort     ;C=0 means fail
        bcc *+2
        brk               ;stop here

     org $2d0
     include "quick.s"

