; Test math instructions

section .data
    digit db 0, 10

section .text
    global _start

_start:
    ; 6 / 2 = 3
    mov rax, 6
    mov rbx, 2
    div rbx
    call _printRAXdigit

    ; 1 + 4 = 5
    mov rax, 1
    add rax, 4
    call _printRAXdigit

    ; exit (syscall 60) with exit code 0
    mov rax, 60
    mov rdi, 0
    syscall

_printRAXdigit:
    ; subroutine to print the current digit from RAX

    ; add 48 to get ASCII representation
    ; because '0' character is 48 in ASCII decimal
    ; up to '9' character which is 57 in ASCII decimal
    add rax, 48

    ; Move the lowest byte of the RAX register (al) to
    ; the memory address pointed by 'digit'.
    ; The 'digit' also contains a newline character, but
    ; it is not overwritten because we only move one byte.
    mov [digit], al

    ; print it normally (length 2 to include newline)
    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 2
    syscall
    ret
