%include "macro.asm"

section .data
    text db "My awesome asm-app!", 10, 0

section .text
    extern _printi, _prints, _strlen
    global _start

_start:
    printi -123
    exit 0
