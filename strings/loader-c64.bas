0 rem for the c64 basic
2 dim aa$(4000):sd=-2
5 print "select sorting method:"
10 print "1. ultrasort (compute 40, 1983)"
20 print "2. lightningsort (compute 52, 1984)"
30 print "3. enhanced quicksort (2021)"
40 print "0. exit"
50 inputk$:if k$="" goto50
60 k=val(k$):if k=0 then end
70 if k=1 thenf$="ultra"
80 if k=2 thenf$="lightning"
90 if k=3 thenf$="enhanced"
100 if k>3 goto10
105 print "loading the sort routine"
110 open8,8,8,f$+"sort,p,r"
120 i=49152:get#8,k$:get#8,k$
130 get#8,k$
140 if k$="" then k$=chr$(0)
150 pokei,asc(k$):i=i+1:if st<>0 goto170
160 goto 130
170 close8:print "the sort routine is loaded"
180 print "how many strings do you want to sort?"
182 print "1. 500"
184 print "2. 1000"
186 print "3. 2000"
187 print "4. 4000"
188 print "0. back"
190 input k$:n=val(k$)
200 if (n<0)or(n>4) goto180
210 if n=0 goto5
220 n=250*2^n
230 print "choose filling method:"
240 print "1. random"
250 print "2. ordered"
260 print "3. reversed"
270 print "4. constant"
280 print "5. two strings"
290 print "6. hundred strings"
300 print "7. slowest for enhanced sort"
310 print "0. back"
320 input k$:r=val(k$)
330 if (r<0)or(r>7) goto230
340 if r=0 goto180
350 print "creating"n;
360 on r gosub1000,1200,1400,1600,1800,2000,2200
370 print "print strings? (y/n)"
380 getk$:if k$="n" goto410
390 if k$<>"y" goto380
400 for i=1 to n:print i;aa$(i):next
410 print "sorting..."
420 t1=ti
430 sys 49152,n,aa$(1)
440 t2=ti
450 print "done"
470 print "print sorted strings? (y/n)"
480 getk$:if k$="n" goto510
490 if k$<>"y" goto480
500 for i=1 to n:print i;aa$(i):next
510 print n" elements sorted in"(t2-t1)/60"seconds"
520 print "sort again? (y/n/b)"
530 getk$:if k$="n" then end
540 if k$="y" goto350
550 if k$="b" goto230
560 goto530
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
2210 open8,8,8,"slow-l-"+mid$(str$(n),2)+",s,r"
2220 for i=1 to n
2230 print i"{up}"
2250 input#8,aa$(i)
2260 next
2265 close8
2270 return
