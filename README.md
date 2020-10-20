# 6502-sorting
implementations of various sorting algos for the 6502

## Byte sorting

Routine  | Size | ZP | Stack | Memory | Startup
---------|------|----|-------|--------|--------
quick    |  273 |  4 |     + |      0 |      14
shell    |  185 |  6 |     - |      0 |      18
selection|      |  6 |     - |      0 |
insertion|      |  6 |     - |      0 |
radix8   |      |  6 |     - |    512 |

### 1000 byte benchmarking

         |    quick |    shell | selection | insertion | radix8 |
---------|----------|----------|-----------|-----------|--------|
random-1 |   561,170|   946,562|           |           |        |
random-2 |   563,155|   925,121|           |           |        |
2-values |   592,443|   540,135|           |           |        |
sorted   |   405,889|   498,261|           |           |        |
constant |   543,401|   498,261|           |           |        |
reversed |   432,879|   682,704|           |           |        |

### 60000 byte benchmarking

         |    quick |    shell | selection | insertion | radix8 |
---------|----------|----------|-----------|-----------|--------|
random-1 |50,389,857|81,808,734|           |           |        |
random-2 |52,883,426|79,152,626|           |           |        |
2-values |53,288,673|49,628,628|           |           |        |
sorted   |39,279,506|45,403,407|           |           |        |
constant |50,961,836|45,403,407|           |           |        |
reversed |40,879,061|61,766,222|           |           |        |

random-1 rand()%256 two times without seeding
random-2 rand()%2
random-3 
sorted 0-255, 0-255, ...
reversed 255-0, 255-0, ...
constant one value

## Word sorting

Routine  | Size | ZP | Stack | Memory | Startup
---------|------|----|-------|--------|--------
quick    |  303 |  4 |     + |      0 |      14
shell    |  203 |  4 |     - |      0 |      18
selection|      |  6 |     - |      0 |
insertion|      |  6 |     - |      0 |

### 1000 word benchmarking

         |     quick |    shell | selection | insertion |
---------|-----------|----------|-----------|-----------|
random-1 |    854,763| 1,380,892|           |           |
random-2 |    847,960| 1,370,632|           |           |
2-values |    861,722|   732,112|           |           |
slow-1   |  1,481,967| 1,153,327|           |           |
slow-2   |  3,139,812| 1,146,841|           |           |
reversed |    445,528|   940,887|           |           |
sorted   |    401,247|   583,839|           |           |
constant |    781,686|   583,839|           |           |

### 30000 word benchmarking

         |     quick |    shell | selection | insertion |
---------|-----------|----------|-----------|-----------|
random-1 | 34,091,790|69,997,697|           |           |
random-2 | 34,223,170|67,518,250|           |           |
2-values | 36,573,891|31,495,608|           |           |
slow-1   | 57,823,525|56,228,315|           |           |
slow-2   |102,682,131|56,110,365|           |           |
reversed | 18,520,138|43,534,213|           |           |
sorted   | 17,200,307|26,299,401|           |           |
constant | 35,401,769|26,299,401|           |           |

random-1 rand()%256 - two times without seeding
random-2 rand()%2 - two times
random-3 
slow-1 kills Hoare's quicksort from right edge
slow-2 kills Hoare's quicksort from left edge

