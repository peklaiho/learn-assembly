extern exit, strcpy

section .data
    text db `JWXtMzfWipEnDNRpEQ7RzTy48p8mhKVN2jSmMGa4CFkCUj4weK5Bv7zcQuyYDd2J\0`

section .bss
    buf1 resb 65

section .text
    global _start

_start:
    mov r15, 1_000_000_00
.loop:
    mov rdi, buf1
    mov rsi, text
    call strcpy

    dec r15
    test r15, r15
    jnz .loop

    ; exit
    mov rdi, 0
    call exit
