; Read input from user

section .data
    text1 db "What is your name? "
    text2 db "Hello, "

section .bss
    ; bss section is used to reserve memory for future use
    ; resb stands for 'reserve bytes' and 16 is length
    name resb 16

section .text
    global _start

_start:
    ; use subroutines
    call _printText1
    call _getName
    call _printText2
    call _printName

    ; exit (syscall 60) with exit code 0
    mov rax, 60
    mov rdi, 0
    syscall

_getName:
    ; read (syscall 0) from STDIN (file descriptor 0) for 16 bytes
    mov rax, 0
    mov rdi, 0
    mov rsi, name
    mov rdx, 16
    syscall
    ret

_printText1:
    mov rax, 1
    mov rdi, 1
    mov rsi, text1
    mov rdx, 19
    syscall
    ret

_printText2:
    mov rax, 1
    mov rdi, 1
    mov rsi, text2
    mov rdx, 7
    syscall
    ret

_printName:
    mov rax, 1
    mov rdi, 1
    mov rsi, name
    mov rdx, 16
    syscall
    ret
