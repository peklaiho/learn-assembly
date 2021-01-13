extern exit, memcmp

section .data
    text1 db `JWXtMzfWipEnDNRpEQ7RzTy48p8mhKVN2jSmMGa4CFkCUj4weK5Bv7zcQuyYDd2J`
    text2 db `JWXtMzfWipEnDNRpEQ7RzTy48p8mhKVN2jSmMGa4CFkCUj4weK5Bv7zcQuyYDd2J`

section .text
    global _start

_start:
    mov r15, 1_000_000_00
.loop:
    mov rdi, text1
    mov rsi, text2
    mov rdx, 64
    call memcmp

    dec r15
    test r15, r15
    jnz .loop

    ; exit
    mov rdi, 0
    call exit
