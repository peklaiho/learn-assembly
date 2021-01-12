;;
;; Calculator
;;

%include "../macro.asm"

;; Definitions in lib.asm
extern exit, gets, itos, stoi, prints

section .data
    ; Strings support special escape characters if they are defined using backticks.
    welcome db `Welcome to calculator app written in assembly!\n\0`
    askOp db `Which operation do you wish to execute (+ - * /)? \0`
    askVal1 db `Please enter the first value to calculate: \0`
    askVal2 db `Please enter the second value to calculate: \0`
    unknownOp db `Unknown operator!\n\0`
    result db `The result is: \0`

section .bss
    bufOp resb 4
    bufVal1 resb 32
    bufVal2 resb 32
    bufRes resb 32

section .text
    global _start

_start:
    call1 prints, welcome
    call1 prints, askOp
    call2 gets, bufOp, 4
    call1 prints, askVal1
    call2 gets, bufVal1, 32
    call1 prints, askVal2
    call2 gets, bufVal2, 32

    call1 stoi, bufVal1
    push rax
    call1 stoi, bufVal2
    mov rdi, rax
    pop rax
    mov rcx, bufOp
    movzx rsi, byte [rcx]
    call _calc

    call2 itos, bufRes, rax
    call1 prints, result
    call1 prints, bufRes
    call1 exit, 0

;; subroutine to perform calculation
;; input: rax, first value
;; input: rdi, second value
;; input: rsi, operator
_calc:
    cmp rsi, '+'
    je .add
    cmp rsi, '-'
    je .sub
    cmp rsi, '*'
    je .mul
    cmp rsi, '/'
    je .div
    call1 prints, unknownOp
    call1 exit, 1
.add:
    add rax, rdi
    jmp .finish
.sub:
    sub rax, rdi
    jmp .finish
.mul:
    imul rdi
    jmp .finish
.div:
    cqo                         ; division uses RDX:RAX as a 128 bit register,
    idiv rdi                    ; cqo copies the sign-bit to RDX
    jmp .finish
.finish:
    ret
