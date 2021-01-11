; File descriptors
STDIN equ 0
STDOUT equ 1
STDERR equ 2

; Syscalls
SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

section .bss
    buffer1 resb 32
    buffer2 resb 32

section .text
    global _exit, _gets, _itos, _stoi, _printc, _printi, _prints, _strlen, _strcpy, _strrcpy

;; ---------------------
;; Exit the program
;; input: rdi, exit code
;; ---------------------

_exit:
    mov rax, SYS_EXIT
    syscall                     ; rdi is passed on unchanged
    ret

;; ---------------------
;; Read input from stdin
;; Note that result includes newline character
;; input: rdi, buffer
;; input: rsi, length
;; ---------------------

_gets:
    mov rax, SYS_READ
    mov rdx, rsi                ; arg3: length
    mov rsi, rdi                ; arg2: buffer
    mov rdi, STDIN              ; arg1: file
    syscall
    ret

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
    jge .loop
    mov r8, 1                   ; set r8 to 1 if number is negative
    neg rax                     ; and change it to positive for processing
.loop:
    mov rdx, 0
    div rsi                     ; divide by 10
    add rdx, 48                 ; convert to ascii
    mov [rcx], dl               ; store one byte in buffer
    inc rcx
    cmp rax, 0                  ; continue if we have more
    jnz .loop
    cmp r8, 0                   ; add sign if negative
    jz .finish
    mov byte [rcx], '-'
    inc rcx
.finish:
    mov byte [rcx], 0           ; terminate with null
    mov rsi, buffer1            ; reverse string using strrcpy
    call _strrcpy               ; rdi is passed along unmodified
    ret

;; -------------------------
;; convert string to integer
;; input: rdi, string
;; output: rax
;; -------------------------

_stoi:
    mov rax, 0
    mov rcx, 0
    mov rsi, 10                 ; multiplier
    mov r8, 0                   ; r8 marks negative number, default to 0
    mov cl, [rdi]               ; check first character
    cmp rcx, '-'
    jne .loop
    mov r8, 1                   ; set r8 to 1 for negative
    inc rdi
.loop:
    mov cl, [rdi]               ; read character
    cmp rcx, 48                 ; < 48, finish
    jl .finish
    cmp rcx, 57                 ; > 57, finish
    jg .finish
    mul rsi                     ; multiple previous result by 10
    sub rcx, 48                 ; convert from ascii (48)
    add rax, rcx                ; and add the value
    inc rdi                     ; start over
    jmp .loop
.finish:
    cmp r8, 0                   ; make negative if r8 is set
    jz .finish2
    neg rax
.finish2:
    ret

;; --------------------------------
;; print single character to stdout
;; input: rdi
;; uses: buffer2
;; --------------------------------

_printc:
    mov rcx, buffer2
    mov [rcx], dil
    mov byte [rcx + 1], 0
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, buffer2
    mov rdx, 1
    syscall
    ret

;; -----------------------
;; print integer to stdout
;; input: rdi
;; uses: buffer2
;; -----------------------

_printi:
    mov rsi, rdi
    mov rdi, buffer2
    call _itos                  ; itos uses buffer1
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
.loop:
    mov cl, [rdi]
    cmp cl, 0
    jz .finish
    inc rax
    inc rdi
    jmp .loop
.finish:
    ret

;; ---------------------------
;; copy null-terminated string
;; input: rdi, destination
;; input: rsi, source
;; output: rax, length
;; ---------------------------

_strcpy:
    mov rax, 0
.loop:
    mov cl, [rsi]
    cmp cl, 0
    jz .finish
    mov [rdi], cl
    inc rax
    inc rdi
    inc rsi
    jmp .loop
.finish:
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
.loop:
    cmp rcx, 0
    jz .finish
    dec rsi                     ; dec before read to exclude null-byte at end
    mov dl, [rsi]
    mov [rdi], dl
    inc rdi
    dec rcx
    jmp .loop
.finish:
    mov byte [rdi], 0
    ret
