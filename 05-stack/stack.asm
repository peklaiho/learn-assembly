; Test stack

section .data
    digit db 0, 10

section .text
    global _start

_start:
    ; Push some values onto the stack
    push 4
    push 8
    push 3

    ; Pop them one by one, printing the result
    pop rax
    call _printRAXdigit
    pop rax
    call _printRAXdigit
    pop rax
    call _printRAXdigit

    ; exit
    mov rax, 60
    mov rdi, 0
    syscall

_printRAXdigit:
    ; subroutine to print the current digit from RAX
    ; see 04-math for explanation
    add rax, 48
    mov [digit], al
    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 2
    syscall
    ret
