;; Macros and constants in NASM
;;
;; The compiler expands macros into code in-place.
;;
;; Example:
;;
;; %macro <name> <argc>
;;     <body>
;; %endmacro
;;
;; Arguments are represented by %1, %2, and so on.

;; Constants are defined using equ
STDOUT equ 1
SYS_WRITE equ 1
SYS_EXIT equ 60

section .data
    digit db 0, 10

section .text
    global _start

%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro

%macro printDigit 1
    mov rax, %1
    call _printRAXdigit
%endmacro

; two arguments
%macro printDigitSum 2
    mov rax, %1
    add rax, %2
    call _printRAXdigit
%endmacro

; If the macro contains a label, and it is used twice
; it does not work, because when the macro is expanded
; the code has a duplicate label!
;
; This can be fixed by prefixing the label with %%.
; Then then compiler will generate unique label name
; each time the macro is expanded.

%macro printTimes 2
    mov rcx, %2                 ; how many times to loop
%%printLoop:
    push rcx                    ; store rcx in stack before syscall
    mov rax, %1
    call _printRAXdigit
    pop rcx                     ; restore rcx
    dec rcx
    cmp rcx, 0
    jne %%printLoop
%endmacro

_start:
    printDigit 3
    printDigit 4

    printDigitSum 2, 3          ; use comma to separate macro arguments

    printTimes 6, 2
    printTimes 7, 2

    exit

_printRAXdigit:
    ; subroutine to print the current digit from RAX
    ; see 04-math for explanation
    add rax, 48
    mov [digit], al
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, digit
    mov rdx, 2
    syscall
    ret
