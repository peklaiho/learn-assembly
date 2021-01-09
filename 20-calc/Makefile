NASM_FLAGS=-g -f elf64

hello: calc.asm lib.asm
	nasm $(NASM_FLAGS) -o lib.o lib.asm
	nasm $(NASM_FLAGS) -o calc.o calc.asm
	ld -o calc calc.o lib.o

clean:
	rm -f calc *.o
