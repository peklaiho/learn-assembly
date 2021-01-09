; Subroutine to print integers.

section .bss
    digits resb 21              ; 20 bytes for characters and 1 for null

section .text
    global _start

_start:
    mov rax, 123
    call _printInt

    mov rax, 60
    mov rdi, 0
    syscall

_printInt:
    mov rcx, digits             ; pointer to buffer
    mov rsi, 10                 ; divide by 10

_printIntLoop:
    mov rdx, 0
    div rsi                     ; perform division

    add rdx, 48                 ; add 48 to convert to ascii
    mov [rcx], rdx              ; store in buffer

    inc rcx                     ; next digit

    cmp rax, 0                  ; continue if we have more digits
    jnz _printIntLoop

    mov rax, 1
    mov rdi, 1
    mov rsi, digits
    mov rdx, 3                  ; hardcoded length for now :(
    syscall
    ret

;; unfinished: prints the digits in reverse, so the order would
;; need to be changed.
