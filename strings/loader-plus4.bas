10 rem for the plus4 basic
20 dim aa$(4000):sd=-2:u=8
220 print "how many strings do you want to sort?"
230 print "1. 500"
240 print "2. 1000"
250 print "3. 2000"
260 print "4. 4000"
280 input k$:n=val(k$)
290 if (n<=0)or(n>4) goto220
310 n=250*2^n
320 print "choose a method of filling:"
330 print "1. random"
340 print "2. ordered"
350 print "3. reversed"
360 print "4. constant"
370 print "5. two strings"
380 print "6. hundred strings"
390 print "7. slowest for enhanced sort"
400 print "0. back"
410 input k$:r=val(k$)
420 if (r<0)or(r>7) goto320
430 if r=0 goto220
440 print "creating"n;
450 on r gosub1000,1200,1400,1600,1800,2000,2200
460 print "print strings? (y/n)"
470 getk$:if k$="n" goto500
480 if k$<>"y" goto470
490 for i=1 to n:print i;aa$(i):next
500 print "sorting..."
510 t1=ti
520 sys4164,n,aa$(1)
530 t2=ti
540 print "done"
550 print "print sorted strings? (y/n)"
560 getk$:if k$="n" goto590
570 if k$<>"y" goto560
580 for i=1 to n:print i;aa$(i):next
590 print "check sorted strings? (y/n)"
600 getk$:if k$="n" goto640
610 if k$<>"y" goto600
620 for i=2 to n:if aa$(i-1)>aa$(i) then print "error: " aa$(i-1) " > " aa$(i):end
630 print i"{up}":next
640 print n" elements sorted in"(t2-t1)/60"seconds"
650 print "sort again? (y/n/b)"
660 getk$:if k$="n" then end
670 if k$="y" goto440
680 if k$="b" goto320
690 goto660
1000 print "random strings"
1010 i=rnd(sd)
1020 for i=1 to n
1030 print i"{up}"
1050 aa$(i)=mid$(str$(1000+int(rnd(1)*8000)),2)
1060 next
1070 return
1200 print "ordered strings"
1220 for i=1 to n
1230 print i"{up}"
1250 aa$(i)=mid$(str$(1000+i),2)
1260 next
1270 return
1400 print "reverse ordered strings"
1420 for i=1 to n
1430 print i"{up}"
1450 aa$(i)=mid$(str$(7000-i),2)
1460 next
1470 return
1600 print "identical strings"
1620 for i=1 to n
1630 print i"{up}"
1650 aa$(i)="12345"
1660 next
1670 return
1800 print "strings mixing two strings"
1810 i=rnd(sd)
1820 for i=1 to n
1830 print i"{up}"
1850 if (rnd(1)>=.5) then aa$(i)="1111":goto1860
1860 a$(i)="2222"
1860 next
1870 return
2000 print "strings mixing 100 strings"
2010 i=rnd(sd)
2020 for i=1 to n
2030 print i"{up}"
2050 aa$(i)=mid$(str$(1000+int(rnd(1)*100)),2)
2060 next
2070 return
2200 print "strings - the worst case for enhanced sort"
2210 open8,u,8,"slow-l-"+mid$(str$(n),2)+",s,r"
2220 for i=1 to n
2230 print i"{up}"
2250 input#8,aa$(i)
2260 next
2265 close8
2270 return
