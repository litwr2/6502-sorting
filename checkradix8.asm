param1 = 10   ;locations for parameters
param2 = 11   ;they can be any two addresses

data = $600   ;sorted array must start here
auxtable = $400  ;address of the auxilary 512 byte array, it must be page aligned
sz = 60000    ;number of elements in the array

        org $200
        lda #>auxtable
        sta param2
        lda #<data
        sta param1
        lda #>data
        ldx #<sz
        ldy #>sz
        jsr radix8
        brk               ;stop here

        org $300
        include "radix8.s"
