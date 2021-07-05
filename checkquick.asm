param = 10   ;a location for a byte parameter
zp1 = 10     ;zero page locations, select any available on your system
zp2 = 12     ;four bytes are required at locations zp1, zp1+1, zp2, and zp2+1

ESZ = 2      ;an element size
data = $400  ;sorted array must start here
sz = 30000   ;number of elements in the array

ODD_OFFSET = (data & 1) && ESZ=2

     org $200
        lda #<data
        sta param
        lda #>data
        ldx #<(data+sz*ESZ-ESZ)
        ldy #>(data+sz*ESZ-ESZ)
        jsr quicksort     ;C=0 means fail
        bcc *+2           ;error, not enough stack space
        brk               ;stop here

     org $2b0
     include "quick.s"
     ;include "quick-nr.s"

