# 6502-sorting
implementations of various sorting algos for the 6502

For each sorting routine the next information is provided:  its size, required amount of zero page locations, whether it uses stack or not, required amount of additional memory, the size of code for its call.  All sizes are in bytes.  Benchmark results are clock cycles.  One clock cycle is equal to one millionth of a second for the 6502 at 1 MHz.  All results were gotten using Fake 6502 v1.1 by Mike Chambers.

Quicksort depends on its *stacklvl* parameter, it must be more than binary logarithm of the number of elements in the sorted array.  Number 26 is used as its default value (16 is enough for any case but it is slower).  Total amount of stack space required may be calculated by *stacklvl\*N*+*stackint* where *N=6* for *quick* and *N=4* for *quick-nr* (nr means no recursion), *stackint* is amount of stack space reserved for interrupts, it is 12 by default.  If interrupts are disabled *stackint* may be equal to 0.  An attempt to use quicksort when your system has less free space on stack causes the immidiate return with *C=0*, *C=1* means the sort is done successfully.

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

The standard C random generator (GCC) is initializared with *srand(0)*.

## Byte sorting

Routine  | Size | ZP | Stack | Memory | Startup
--------:|-----:|---:|------:|-------:|-------:
quick    |  269 |  4 |   170¹|      0 |      15
quick-nr |  297 |  4 |   118²|      0 |      15
shell    |  185 |  4 |     2 |      0 |      17
selection|  105 |  6 |     2 |      0 |      13
insertion|  111 |  4 |     2 |      0 |      13
radix8   |  179 |  0 |     2 |    512 |      17

¹ - *stacklvl\*6 + stackint + 2*

² - *stacklvl\*4 + stackint + 2*

### 1000 byte benchmarking

  &nbsp; |    quick | quick-nr|   shell |  selection |  insertion | radix8
--------:|---------:|--------:|--------:|-----------:|-----------:|-------:
random-1 |  555,543 | 573,590 | 928,279 | 21,849,633 | 20,245,928 | 116,245
random-2 |  557,576 | 567,924 | 893,363 | 21,842,846 | 15,765,505 | 116,245
2-values |  587,226 | 573,732 | 531,092 | 21,800,980 |  9,836,172 | 116,281
reversed |  427,344 | 468,890 | 691,077 | 22,518,521 | 39,897,511 | 116,245
sorted   |  400,358 | 441,751 | 474,679 | 21,795,403 |     68,057 | 116,245
constant |  539,818 | 530,394 | 474,679 | 21,795,403 |     68,057 | 116,299

### 60000 byte benchmarking

  &nbsp; |    quick | quick-nr |    shell |    selection |     insertion |  radix8 
--------:|---------:|---------:|---------:|-------------:|--------------:|--------:
random-1 |50,084,264|49,308,411|81,808,727|73,841,817,729| 71,753,189,527|6,138,745
random-2 |50,352,956|49,573,209|79,152,619|73,842,008,997| 71,361,558,843|6,139,843
2-values |52,963,822|52,105,581|49,628,621|73,838,795,941| 35,873,116,976|6,142,597
reversed |40,632,214|40,084,966|61,766,215|73,880,895,900|143,557,968,552|6,138,745
sorted   |39,033,107|38,487,043|45,403,400|73,838,463,983|      4,084,215|6,138,745
constant |50,732,461|50,126,301|45,403,400|73,838,463,983|      4,084,215|6,142,615

## Word sorting

Routine  | Size | ZP | Stack | Memory | Startup
--------:|-----:|---:|------:|-------:|-------:
quick    |  299 |  4 |   170¹|      0 |      15
quick_nr |  327 |  4 |   118²|      0 |      15
shell    |  203 |  4 |     2 |      0 |      17
selection|  113 |  6 |     2 |      0 |      13
insertion|  119 |  4 |     2 |      0 |      13

### 1000 word benchmarking

  &nbsp; |   quick | quick-nr|   shell | selection | insertion 
--------:|--------:|--------:|--------:|----------:|----------:
random-1 |  848,322|  896,496|1,408,544| 27,245,650| 32,354,462
random-2 |  841,787|  884,282|1,327,677| 27,248,983| 27,659,089
4-values |  855,787|  840,639|  720,611| 27,197,679| 24,218,437
kill-qs-r|1,476,191|1,471,196|1,143,963| 27,205,214| 21,276,928
kill-qs-l|3,133,484|1,488,521|1,138,923| 27,202,299| 21,276,584
reversed |  441,945|  432,521|  962,595| 29,935,843| 63,558,635
sorted   |  397,664|  388,240|  557,223| 27,185,843|     80,117
constant |  778,103|  768,679|  557,223| 27,185,843|     80,117

### 30000 word benchmarking

  &nbsp; |     quick |  quick-nr |    shell |    selection |    insertion 
--------:|----------:|----------:|---------:|-------------:|-------------:
random-1 | 33,905,191| 35,192,986|69,997,690|23,864,359,057|28,620,322,004
random-2 | 33,733,085| 34,642,874|67,518,243|23,864,371,355|28,465,154,829
4-values | 36,417,240| 36,003,856|31,495,601|23,861,826,868|21,361,142,593
kill-qs-r| 57,628,807| 57,312,313|56,228,308|23,862,054,975|19,072,438,381
kill-qs-l|102,508,789| 66,820,139|56,110,358|23,861,964,819|19,072,437,332
reversed | 18,405,451| 18,102,395|43,534,206|26,336,469,863|57,209,527,759
sorted   | 17,085,620| 16,782,564|26,299,394|23,861,469,863|     2,404,203
constant | 35,287,082| 34,984,026|26,299,394|23,861,469,863|     2,404,203

Check also [Z80-sorting](https://github.com/litwr2/Z80-sorting) and [6809-sorting](https://github.com/litwr2/6809-sorting).
