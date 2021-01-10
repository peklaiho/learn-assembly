%include "macro.asm"

section .bss
    buffer1 resb 32
    buffer2 resb 32

section .text
    global _itos, _printi, _prints, _strlen, _strcpy, _strrcpy

;; -----------------------------------------
;; convert integer to null-terminated string
;; input: rdi, buffer for string
;; input: rsi, integer to convert
;; uses: buffer1
;; -----------------------------------------

_itos:
    mov rax, rsi
    mov rcx, buffer1            ; rcx is pointer to temp buffer
    mov rsi, 10                 ; rsi is divisor

    mov r8, 0                   ; r8 marks negative numbers, default to 0
    cmp rax, 0
    jge _itosLoop
    mov r8, 1                   ; set r8 to 1 if number is negative
    neg rax                     ; and change it to positive for processing

_itosLoop:
    mov rdx, 0
    div rsi                     ; divide by 10

    add rdx, 48                 ; convert to ascii
    mov [rcx], rdx              ; store in buffer
    inc rcx

    cmp rax, 0                  ; continue if we have more
    jnz _itosLoop

    cmp r8, 0                   ; add sign if negative
    jz _itosFinish
    mov byte [rcx], '-'
    inc rcx

_itosFinish:
    mov byte [rcx], 0           ; terminate with null

    mov rsi, buffer1            ; reverse string using strrcpy
    call _strrcpy               ; and write it to rdi
    ret

;; -----------------------
;; print integer to stdout
;; input: rdi
;; uses: buffer2
;; -----------------------

_printi:
    mov rsi, rdi
    mov rdi, buffer2
    call _itos
    mov rdi, buffer2
    call _prints
    ret

;; --------------------------------------
;; print null-terminated string to stdout
;; input: rdi
;; --------------------------------------

_prints:
    mov rsi, rdi                ; arg2: string (strlen does not modify rsi)
    call _strlen                ; length into rax
    mov rdi, STDOUT             ; arg1: stdout
    mov rdx, rax                ; arg3: length
    mov rax, SYS_WRITE          ; syscall id
    syscall
    ret

;; ------------------------------------------
;; calculate length of null-terminated string
;; input: rdi
;; output: rax
;; ------------------------------------------

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

;; ---------------------------
;; copy null-terminated string
;; input: rdi, destination
;; input: rsi, source
;; output: rax, length
;; ---------------------------

_strcpy:
    mov rax, 0
_strcpyLoop:
    mov cl, [rsi]
    cmp cl, 0
    jz _strcpyFinish
    mov [rdi], cl
    inc rax
    inc rdi
    inc rsi
    jmp _strcpyLoop
_strcpyFinish:
    mov byte [rdi], 0
    ret

;; --------------------------------------
;; copy null-terminated string in reverse
;; input: rdi, destination
;; input: rsi, source
;; output: rax, length
;; --------------------------------------

_strrcpy:
    push rdi                    ; store rdi in stack (strlen does not modify rsi)
    mov rdi, rsi
    call _strlen                ; calculate length into rax
    pop rdi
    mov rcx, rax                ; use rcx as counter
    add rsi, rax                ; increase source pointer
_strrcpyLoop:
    cmp rcx, 0
    jz _strrcpyFinish
    dec rsi                     ; dec before read to exclude null-byte at end
    mov dl, [rsi]
    mov [rdi], dl
    inc rdi
    dec rcx
    jmp _strrcpyLoop
_strrcpyFinish:
    mov byte [rdi], 0
    ret
