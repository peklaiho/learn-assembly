;;
;; Calculator
;;

;; Definitions in lib.asm
extern _exit, _gets, _stoi, _printc, _printi, _prints

;; Macros

%macro exit 1
    mov rdi, %1
    call _exit
%endmacro

%macro gets 2
    mov rdi, %1
    mov rsi, %2
    call _gets
%endmacro

%macro stoi 1
    mov rdi, %1
    call _stoi
%endmacro

%macro printc 1
    mov rdi, %1
    call _printc
%endmacro

%macro printi 1
    mov rdi, %1
    call _printi
%endmacro

%macro prints 1
    mov rdi, %1
    call _prints
%endmacro

;; End of macros

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

section .text
    global _start

_start:
    prints welcome              ; read input from user
    prints askOp
    gets bufOp, 4
    prints askVal1
    gets bufVal1, 32
    prints askVal2
    gets bufVal2, 32
    stoi bufVal1                ; convert args from string to int
    push rax
    stoi bufVal2
    mov rdi, rax
    pop rax
    mov rcx, bufOp              ; store operator in rsi
    mov rsi, 0
    mov sil, [rcx]
    call _calc                  ; call subroutine
    mov rbx, rax
    prints result               ; print the result
    printi rbx
    printc 10
    exit 0

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
    prints unknownOp
    exit 1
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
