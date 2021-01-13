NASM_FLAGS=-f elf64

all: memcmp memcpy memset strcmp strcpy strlen

lib:
	nasm $(NASM_FLAGS) -o lib.o ../lib.asm

memcmp: lib
	nasm $(NASM_FLAGS) -o memcmp.o memcmp.asm
	ld -o bm-memcmp memcmp.o lib.o

memcpy: lib
	nasm $(NASM_FLAGS) -o memcpy.o memcpy.asm
	ld -o bm-memcpy memcpy.o lib.o

memset: lib
	nasm $(NASM_FLAGS) -o memset.o memset.asm
	ld -o bm-memset memset.o lib.o

strcmp: lib
	nasm $(NASM_FLAGS) -o strcmp.o strcmp.asm
	ld -o bm-strcmp strcmp.o lib.o

strcpy: lib
	nasm $(NASM_FLAGS) -o strcpy.o strcpy.asm
	ld -o bm-strcpy strcpy.o lib.o

strlen: lib
	nasm $(NASM_FLAGS) -o strlen.o strlen.asm
	ld -o bm-strlen strlen.o lib.o

clean:
	rm -f bm* *.o
