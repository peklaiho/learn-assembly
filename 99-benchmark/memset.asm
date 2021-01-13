extern exit, memset

section .bss
    buf1 resb 1024

section .text
    global _start

_start:
    mov r15, 1_000_000_00
.loop:
    mov rdi, buf1
    mov rsi, 123
    mov rdx, 1024
    call memset

    dec r15
    test r15, r15
    jnz .loop

    ; exit
    mov rdi, 0
    call exit
