; Hello World using subroutine.
; Same as 01-hello but the printing is moved
; into a subroutine.

section .data
    text db "Hello, World!",10

section .text
    global _start

_start:
    ; call our subroutine
    call _printHello

    ; exit
    mov rax, 60
    mov rdi, 0
    syscall

_printHello:
    ; print using syscall like before
    mov rax, 1
    mov rdi, 1
    mov rsi, text
    mov rdx, 14
    syscall

    ; Use ret to return from the subroutine
    ; and continue the execution from the
    ; point where the call was made.
    ret
