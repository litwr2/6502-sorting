10 rem v3, commodore+4 basic
20 dim aa$(4000):sx=27:dim ss(sx):sp=sx:sd=-2
30 print"basic, ml or exit? (b/m/e)"
40 getk$:if k$="e" thenend
50 c=0:if k$="b" then70
60 c=1:if k$<>"m" then40
70 input"number of strings to sort (0-back)";k$:n=val(k$)
80 if(n<0)or(n>4000)goto70
90 if n=0 goto30
300 print"choose a method of filling:"
310 print"1. random"
320 print"2. ordered"
330 print"3. reversed"
340 print"4. constant"
350 print"5. 2 random strings"
360 print"6. 100 random strings"
370 print"7. slowest for hoare sort (r)"
380 print"8. slowest for hoare sort (l)"
390 print"9. empty"
400 print"0. back"
410 input k$:r=val(k$)
420 if (r<0)or(r>9) goto300
430 if r=0 goto70
440 print"creating"n;
450 on r gosub1000,1200,1400,1600,1800,2000,2200,2600,2400
460 print"print strings? (y/n)"
470 getk$:if k$="n" goto500
480 if k$<>"y" goto470
490 for i=1 to n:print i;aa$(i):next
500 print"sorting..."
510 gosub900:t1=ti
520 if c=1 then sys4145,n,aa$(1)
525 if c=0 then pl=1:pu=n:gosub5000
530 t2=ti:print n"elements sorted in"(t2-t1)/60"seconds"
540 print"checking..."
550 for i=2 to n:if aa$(i-1)>aa$(i) then print "error: "i": "aa$(i-1)" > "aa$(i):end
560 print i"{up}":next
580 print"print sorted strings? (y/n)"
590 getk$:if k$="n" goto650
600 if k$<>"y" goto590
610 for i=1 to n:print i;aa$(i):next
650 print"sort again? (y/n/b)"
660 getk$:if k$="n" then end
670 if k$="y" goto440
680 if k$="b" goto300
690 goto660
900 k=0:t2=0:pl=0:pu=0:pj=0:p1=0:x$=""
910 return
1000 print"random strings"
1010 i=rnd(sd)
1020 for i=1 to n
1030 print i"{up}"
1050 aa$(i)=mid$(str$(1000+int(rnd(1)*8000)),2)
1060 next
1070 return
1200 print"ordered strings"
1220 for i=1 to n
1230 print i"{up}"
1250 aa$(i)=mid$(str$(1000+i),2)
1260 next
1270 return
1400 print"reverse ordered strings"
1420 for i=1 to n
1430 print i"{up}"
1450 aa$(i)=mid$(str$(7000-i),2)
1460 next
1470 return
1600 print"identical strings"
1620 for i=1 to n
1630 print i"{up}"
1650 aa$(i)="1234"
1660 next
1670 return
1800 print"strings mixing 2 strings"
1810 i=rnd(sd)
1820 for i=1 to n
1830 print i"{up}"
1850 if (rnd(1)>=.5) then aa$(i)="1111":next
1860 aa$(i)="2222"
1860 next
1870 return
2000 print"strings mixing 100 strings"
2010 i=rnd(sd)
2020 for i=1 to n
2030 print i"{up}"
2050 aa$(i)=mid$(str$(1000+int(rnd(1)*100)),2)
2060 next
2070 return
2200 print" strings: the worst case for hoare sort (r)"
2205 if (nand1)<>0 then print"use an even number of elements!":goto2270
2210 aa$(1)="1001":aa$(2)="1003":aa$(3)="1005":aa$(4)="1000":aa$(5)="1002":aa$(6)="1004"
2220 for i=3 to n/2-1
2230 aa$(i+i+1)=aa$(i+1):aa$(i+i+2)=mid$(str$(val(aa$(i+i))+2),2):aa$(i+1)=mid$(str$(i+i+1001),2)
2240 print i"{up}"
2250 next
2270 return
2400 print"empty strings"
2420 for i=1 to n
2430 print i"{up}"
2450 aa$(i)=""
2460 next
2470 return
2600 print" strings: the worst case for hoare sort (l)"
2605 if (nand1)<>0 then2205
2610 k=n/2
2620 for i=0 to k-1
2630 gosub2700:aa$(k-i)=mid$(str$(p1+1000),2):aa$(i+k+1)=mid$(str$(i+i+1001),2)
2640 print i"{up}"
2650 next
2670 return
2700 if i=0 then p1=0:return
2710 if (k-iand1)=0 then p1=k-i:return
2720 pu=(k+i-1)/2:gosub2730:p1=p1+k-i+1:return
2730 if (pu and1)=1 then p1=pu-1:return
2740 ss(sp)=pu:sp=sp-1:pu=pu/2:gosub2730:sp=sp+1:pu=ss(sp):p1=pu+p1:return
5000 rem non-recursive quicksort
5010 p1=pl:pj=pu:k=int((p1+pj)/2):k$=aa$(k)
5020 if aa$(p1)<k$ then p1=p1+1:goto5020
5030 if aa$(pj)>k$ then pj=pj-1:goto5030
5040 if p1>pj then5070
5050 if p1<>pj then x$=aa$(p1):aa$(p1)=aa$(pj):aa$(pj)=x$
5060 p1=p1+1:pj=pj-1
5070 if p1<=pj goto5020
5080 if pj>k goto5160
5090 if pl>=pj goto5130
5100 ss(sp)=pu:sp=sp-1
5110 ss(sp)=p1:sp=sp-1
5120 pu=pj:goto5010
5130 if p1>=pu goto5240
5140 pl=p1:goto5010
5160 if p1>=pu goto5200
5170 ss(sp)=pj:sp=sp-1
5180 ss(sp)=pl:sp=sp-1
5190 pl=p1:goto5010
5200 if pl>=pj goto5240
5230 pu=pj:goto5010
5240 if sp=sx then return
5250 sp=sp+1:pl=ss(sp)
5260 sp=sp+1:pu=ss(sp)
5270 goto5010
