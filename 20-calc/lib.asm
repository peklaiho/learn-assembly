%include "macro.asm"

section .bss
    buffer resb 32

section .text
    global _printi, _prints, _strlen

;; print integer to stdout
;; input: rdi

_printi:
    mov rax, rdi
    neg rax
    mov rcx, buffer
    mov rsi, 10
_printiLoop:
    mov rdx, 0
    div rsi                     ; divide by 10
    add rdx, 48                 ; convert to ascii
    mov [rcx], rdx              ; store in buffer
    inc rcx
    cmp rax, 0                  ; continue if we have more
    jnz _printiLoop
    mov byte [rcx], 0           ; terminate with null
    mov rdi, buffer             ; print the string
    call _prints
    ret

;; print null-terminated string to stdout
;; input: rdi

_prints:
    push rdi
    call _strlen                ; length into rax
    mov rdi, STDOUT             ; arg1: stdout
    pop rsi                     ; arg2: string, from stack
    mov rdx, rax                ; arg3: length
    mov rax, SYS_WRITE          ; syscall id
    syscall
    ret

;; calculate length of null-terminated string
;; input: rdi
;; output: rax

_strlen:
    mov rax, 0
_strlenLoop:
    mov cl, [rdi]
    cmp cl, 0
    jz _strlenFinish
    inc rax
    inc rdi
    jmp _strlenLoop
_strlenFinish:
    ret
