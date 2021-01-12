; File descriptors
STDIN equ 0
STDOUT equ 1
STDERR equ 2

; Syscalls
SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

section .text

;; Exit the program
;; Inputs: RDI = exit code

global exit
exit:
    mov rax, SYS_EXIT
    syscall                     ; rdi is passed on unchanged
    ret

;; Read input from stdin
;; Note that result includes newline character
;; Inputs: RDI = buffer, RSI = length

global gets
gets:
    mov rax, SYS_READ
    mov rdx, rsi                ; arg3: length
    mov rsi, rdi                ; arg2: buffer
    mov rdi, STDIN              ; arg1: file
    syscall
    ret

;; Convert integer to null-terminated string
;; Inputs: RDI = string, RSI = integer

global itos
itos:
    cld
    xor rcx, rcx
    mov rax, rsi
    mov rsi, 10                 ; divisor
    xor r8, r8                  ; r8 marks negative
    cmp rax, 0
    jge .loopPush
    mov r8, 1
    neg rax
.loopPush:
    mov rdx, 0
    div rsi
    add rdx, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .loopPush
    test r8, r8
    jz .loopPop
    mov rax, '-'
    stosb
.loopPop:
    pop rax
    stosb
    dec rcx
    test rcx, rcx
    jnz .loopPop
    mov byte [rdi], 0           ; null-terminator
    ret

;; Convert string to integer
;; Inputs: RDI

global stoi
stoi:
    xor rax, rax
    xor rcx, rcx
    mov rsi, 10                 ; multiplier
    xor r8, r8                  ; r8 marks negative
    mov cl, [rdi]
    cmp cl, '-'
    jne .loop
    mov r8, 1
    inc rdi
.loop:
    mov cl, [rdi]
    cmp cl, '0'
    jl .finish
    cmp cl, '9'
    jg .finish
    mul rsi                     ; multiply previous value
    sub cl, '0'
    add rax, rcx
    inc rdi
    jmp .loop                   ; start over
.finish:
    test r8, r8
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
;; Inputs: RDI

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
    cld
.loop:
    lodsb
    stosb
    test al, al
    jnz .loop
    ret

;; Calculate length of null-terminated string
;; Inputs: RDI

global strlen
strlen:
    xor rax, rax
    mov rcx, -1
    cld
    repne scasb                 ; loop until [rdi] != rax
    mov rax, rcx
    add rax, 2
    neg rax
    ret
