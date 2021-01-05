; Include code from another file

; Use %include to include other file
; the contents of the file are added in-place.
%include "includes.asm"

section .data
    text db "Hello, World!", 10

section .text
    global _start

_start:
    print text, 14
    exit
