; File descriptors
STDIN equ 0
STDOUT equ 1
STDERR equ 2

; Syscalls
SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

%macro printi 1
    mov rdi, %1
    call _printi
%endmacro

%macro prints 1
    mov rdi, %1
    call _prints
%endmacro

%macro strlen 1
    mov rdi, %1
    call _strlen
%endmacro

%macro exit 1
    mov rax, SYS_EXIT
    mov rdi, %1
    syscall
%endmacro
