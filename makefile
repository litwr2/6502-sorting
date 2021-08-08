CFLAGS = -O3
checksort: checksort.o
checksort.o: checksort.c data.h
insertion selection shell radix8 quick:
	./compile check$@.asm
	make
	./checksort out.prg
clean:
	rm checksort out.* data.h
