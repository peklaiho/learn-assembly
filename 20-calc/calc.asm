%include "macro.asm"

section .data
    ; Strings support special escape characters if
    ; they are defined using backticks.
    text db `My awesome asm-app!\n\0`

section .text
    extern _printi, _prints, _strlen
    global _start

_start:
    prints text
    printi 123
    exit 0
