;; Subroutine to print null-terminated strings

section .data
    ; null-terminated strings
    text1 db "Hello, World!", 10, 0
    text2 db "Null-terminated strings are Awesome!", 10, 0

section .text
    global _start

_start:
    mov rax, text1
    call _print

    mov rax, text2
    call _print

    ; exit (syscall 60) with exit code 0
    mov rax, 60
    mov rdi, 0
    syscall

;; subroutine to calculate string length
;; input: rax as pointer to string
;; output: rcx as length of the string
_strlen:
    push rax                    ; store original value of rax in stack
    mov rcx, 0                  ; initialize counter to zero
_strlenLoop:
    mov bl, [rax]               ; inspect next byte
    cmp bl, 0                   ; compare with zero
    je _strlenFinish            ; if zero, jump to end
    inc rax                     ; increment rax
    inc rcx                     ; increment counter
    jmp _strlenLoop             ; jump to start of loop
_strlenFinish:
    pop rax                     ; restore rax to original value
    ret

;; subroutine to print a null-terminated string
;; input: rax as pointer to string
_print:
    ; read the length into rcx
    call _strlen
    ; write to stdout
    mov rsi, rax
    mov rdx, rcx
    mov rax, 1
    mov rdi, 1
    syscall
    ret
