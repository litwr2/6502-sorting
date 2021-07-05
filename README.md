# 6502-sorting
implementations of various sorting algos for the 6502

For each sorting routine the next information is provided:  its size, required amount of zero page locations, whether it uses stack or not, required amount of additional memory, the size of code for its call.  All sizes are in bytes.  Benchmark results are clock cycles.  One clock cycle is equal to one millionth of a second for the 6502 at 1 MHz.  All results were gotten using Fake 6502 v1.1 by Mike Chambers.

Quicksort depends on its *stacklvl* parameter, it must be more than binary logarithm of the number of elements in the sorted array.  Number 26 is used as its default value (16 is enough for any case but it is slower).  Total amount of stack space required may be calculated by *stacklvl*x*N*+*stackint* where *N=6* for *quick* and *N=4* for *quck-nr*, *stackint* is amount of stack space reserved for interrupts, it is 10 by default.  If interrupts are disabled *stackint* may be equal to 0.  An attempt to use quicksort when your system has less free space on stack causes the immidiate return with *C=0*, *C=1* means the sort is done successfully.

Shellsort depends on its *shelltabidx* parameter which is used in a normal Shellsort invocation.  For the benchmarks, the value 7 has been used for 1000 element arrays, and the value 11 has been used for 30000 and 60000 element arrays.

Various kinds of filling have been used for testing and benchmarking:
  * *random-1* &ndash; every byte is generated randomly by the standard C random number generator function, numbers in range 0 and 255 are generated;
  * *random-2* &ndash; every byte is generated randomly by a quick and simple homebrew random number generator, numbers in range 0 and 255 are generated;
  * *2-values* &ndash; every byte is generated randomly by the standard C random number generator function, only numbers 0 and 1 are generated;
  * *4-values* &ndash; every 16-bit word is generated randomly by the standard C random number generator function, only numbers 0, 1, 256 and 257 are generated;
  * *killer-qs-r* &ndash; this sequence kills Hoare's Quicksort from its right edge;
  * *killer-qs-l* &ndash; this sequence kills Hoare's Quicksort from its left edge;
  * *reversed* &ndash; every next element is equal or lower than the previous;
  * *sorted* &ndash; every next element is equal or higher than the previous;
  * *constant* &ndash; all elements are equal.

The killer sequence generators may be taken from this [file](https://github.com/litwr2/research-of-sorting/blob/master/fillings.cpp), seek for *fill_for_quadratic_qsort_hoare* routines.  The *random-2* generator is available within the same file, seek for *fill_homebrew_randomly* routine.

## Byte sorting

Routine  | Size | ZP | Stack | Memory | Startup
--------:|-----:|---:|------:|-------:|-------:
quick    |  269 |  4 |     + |      0 |      15
quick-nr |  297 |  4 |     + |      0 |      15
shell    |  185 |  4 |     - |      0 |      17
selection|  105 |  6 |     - |      0 |      13
insertion|  111 |  4 |     - |      0 |      13
radix8   |  179 |  0 |     - |    512 |      17

### 1000 byte benchmarking

  &nbsp; |    quick | quick-nr|   shell |  selection |  insertion | radix8
--------:|---------:|--------:|--------:|-----------:|-----------:|-------:
random-1 |  555,550 | 573,597 | 928,286 | 21,849,640 | 20,245,935 | 116,252
random-2 |  557,583 | 567,931 | 893,370 | 21,842,853 | 15,765,512 | 116,252
2-values |  587,233 | 573,739 | 531,099 | 21,800,987 |  9,836,179 | 116,288
reversed |  427,351 | 468,897 | 691,084 | 22,518,528 | 39,897,518 | 116,252
sorted   |  400,365 | 441,758 | 474,686 | 21,795,410 |     68,064 | 116,252
constant |  539,825 | 530,401 | 474,686 | 21,795,410 |     68,064 | 116,306

### 60000 byte benchmarking

  &nbsp; |    quick | quick-nr |    shell |    selection |     insertion |  radix8 
--------:|---------:|---------:|---------:|-------------:|--------------:|--------:
random-1 |50,084,271|49,308,418|81,808,734|73,841,817,736| 71,753,189,534|6,138,752
random-2 |50,352,963|49,573,216|79,152,626|73,842,009,004| 71,361,558,850|6,139,850
2-values |52,963,829|52,105,588|49,628,628|73,838,795,948| 35,873,116,983|6,142,604
reversed |40,632,221|40,084,973|61,766,222|73,880,895,907|143,557,968,559|6,138,752
sorted   |39,033,114|38,487,050|45,403,407|73,838,463,990|      4,084,222|6,138,752
constant |50,732,468|50,126,308|45,403,407|73,838,463,990|      4,084,222|6,142,622

## Word sorting

Routine  | Size | ZP | Stack | Memory | Startup
--------:|-----:|---:|------:|-------:|-------:
quick    |  299 |  4 |     + |      0 |      15
quick_nr |  327 |  4 |     + |      0 |      15
shell    |  203 |  4 |     - |      0 |      17
selection|  113 |  6 |     - |      0 |      13
insertion|  119 |  4 |     - |      0 |      13

### 1000 word benchmarking

  &nbsp; |   quick | quick-nr|   shell | selection | insertion 
--------:|--------:|--------:|--------:|----------:|----------:
random-1 |  848,329|  896,503|1,408,551| 27,245,657| 32,354,469
random-2 |  841,794|  884,289|1,327,684| 27,248,990| 27,659,096
4-values |  855,794|  840,646|  720,618| 27,197,686| 24,218,444
kill-qs-r|1,476,198|1,471,203|1,143,970| 27,205,221| 21,276,935
kill-qs-l|3,133,491|1,488,528|1,138,930| 27,202,306| 21,276,591
reversed |  441,952|  432,528|  962,602| 29,935,850| 63,558,642
sorted   |  397,671|  388,247|  557,230| 27,185,850|     80,124
constant |  778,110|  768,686|  557,230| 27,185,850|     80,124

### 30000 word benchmarking

  &nbsp; |     quick |  quick-nr |    shell |    selection |    insertion 
--------:|----------:|----------:|---------:|-------------:|-------------:
random-1 | 33,905,198| 35,192,993|69,997,697|23,864,359,064|28,620,322,011
random-2 | 33,733,092| 34,642,881|67,518,250|23,864,371,362|28,465,154,836
4-values | 36,417,247| 36,003,863|31,495,608|23,861,826,875|21,361,142,600
kill-qs-r| 57,628,814| 57,312,320|56,228,315|23,862,054,982|19,072,438,388
kill-qs-l|102,508,796| 66,820,146|56,110,365|23,861,964,826|19,072,437,339
reversed | 18,405,458| 18,102,402|43,534,213|26,336,469,870|57,209,527,766
sorted   | 17,085,627| 16,782,571|26,299,401|23,861,469,870|     2,404,210
constant | 35,287,089| 34,984,033|26,299,401|23,861,469,870|     2,404,210

Check also [Z80-sorting](https://github.com/litwr2/Z80-sorting).
