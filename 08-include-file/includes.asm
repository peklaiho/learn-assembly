;; Define some constants and macros

STDOUT equ 1
SYS_WRITE equ 1
SYS_EXIT equ 60

%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro

%macro print 2
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro
