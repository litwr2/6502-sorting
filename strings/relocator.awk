BEGIN {p = 0x200}
f == 1 {
    f = 0
    t = strtonum("0x"substr($1,9,4)) + 1
    s = t - p
    p = t
    if (x == 0) o = "    byte "
    o = o sprintf("$%x", s)
    x = (x + 1)%16
    if (x == 0) print o; else o = o ","
}
/##/ {
    f = 1
}
END {
    if (x != 0) print substr(o, 1, length(o) - 1)
    print "    byte $ff"
}
