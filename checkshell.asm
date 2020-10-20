addrhi = 10     ;locations for parameters
addrlo = 11     ;they can be any addresses

ESZ = 2      ;the element size
shelltabidx = 7  ;the default index to the gap table, the first index is equal to 1
                  ;for the best speed, the indexed value should be maximal but close to sz/2
                  ;it is safe to always set it to the max value 11
data = $400  ;sorted array must start here
sz = 1000   ;number of elements in the array

        org $200
        lda #<data
        sta addrlo
        lda #>data
        sta addrhi
        ldx #<(data+sz*ESZ)
        ldy #>(data+sz*ESZ)
        lda #shelltabidx*2  ;may be less
        jsr shellsort
        brk               ;stop here

        org $300
        include "shell.s"
