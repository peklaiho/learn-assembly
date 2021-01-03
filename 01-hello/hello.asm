; Hello World in x86-64 assembly

section .data
    ; define constant named 'text'
    ; db stands for 'define bytes'
    ; 10 is the newline character "\n" in decimal
    text db "Hello, World!",10

section .text
    global _start

_start:
    ; write (syscall 1) to file descriptor 1 (STDOUT)
    ; 14 is the length of how many bytes to write
    mov rax, 1
    mov rdi, 1
    mov rsi, text
    mov rdx, 14
    syscall

    ; exit (syscall 60) with exit code 0
    mov rax, 60
    mov rdi, 0
    syscall
