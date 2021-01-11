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

;; ---------------------
;; Exit the program
;; input: rdi, exit code
;; ---------------------

global _exit
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

global _gets
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

global _itos
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
    ; call _strrcpy               ; rdi is passed along unmodified
    ret

;; -------------------------
;; convert string to integer
;; input: rdi, string
;; output: rax
;; -------------------------

global _stoi
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

;; Copy bytes from source to destination
;; Inputs: RDI = destination, RSI = source, RDX = length

global memcpy
memcpy:
    mov rcx, rdx
    cld
    rep movsb                   ; copy RCX bytes from RSI to RDI
    ret

;; Set bytes to specified value
;; Inputs: RDI = destination, RSI = value to set, RDX = length

global memset
memset:
    mov rax, rsi
    mov rcx, rdx
    cld
    rep stosb
    ret

;; Print null-terminated string to stdout
;; Input: RDI

global prints
prints:
    mov rsi, rdi                ; arg2: string (strlen does not modify rsi)
    call strlen                 ; length into rax
    mov rdi, STDOUT             ; arg1: stdout
    mov rdx, rax                ; arg3: length
    mov rax, SYS_WRITE          ; syscall id
    syscall
    ret

;; Copy null-terminated string
;; Inputs: RDI = destination, RSI = source

global strcpy
strcpy:
    test sil, sil

    movsb                       ; copy one byte from RSI to RDI
    test

    mov r8, rdi                 ; store rdi in r8
    mov rdi, rsi
    call strlen                 ; length into rax
    mov rdi, r8
    mov rcx, rax
    inc rcx                     ; include null-terminator
    cld                         ; clear the DF flag
    rep movsb                   ; copy RCX bytes from RSI to RDI
    ret

;; Calculate length of null-terminated string
;; Inputs: RDI

global strlen
strlen:
    xor rax, rax
    mov rdx, rdi                ; store rdi in rdx
    mov rcx, -1
    cld
    repne scasb                 ; loop until [rdi] != rax
    mov rax, rdi
    sub rax, rdx
    dec rax                     ; remove null-terminator
    ret
