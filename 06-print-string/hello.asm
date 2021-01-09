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
;; output: rax as length of the string
_strlen:
    mov rcx, 0                  ; initialize counter to zero
_strlenLoop:
    mov dl, [rax]
    cmp dl, 0                   ; compare with zero
    jz _strlenFinish            ; if zero, jump to end
    inc rax                     ; increment rax
    inc rcx                     ; increment counter
    jmp _strlenLoop             ; jump to start of loop
_strlenFinish:
    mov rax, rcx                ; return result in rax
    ret

;; subroutine to print a null-terminated string
;; input: rax as pointer to string
_print:
    push rax                    ; store string address in stack
    call _strlen                ; calculate length
    mov rdi, 1                  ; arg1: stdout
    pop rsi                     ; arg2: string pointer
    mov rdx, rax                ; arg3: length
    mov rax, 1                  ; syscall id
    syscall
    ret
