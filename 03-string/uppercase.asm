;-----------------------------------------------------------
; This is a practice of converting lowercase into uppercase
; 
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcrt.dll
;-----------------------------------------------------------

        global  main
        extern  printf
        extern  strlen
        section .data
hello:  db      'Hello world', 0
fmt:    db      'result: %s', 0xd, 0xa, 0

        section .bss
len:    resq    1

        section .text
main:
        ; get string length by strlen()
        mov     rcx, hello
        sub     rsp, 32
        call    strlen
        add     rsp, 32
        mov     qword [len], rax

        ; translate lower case to upper case
        mov     rcx, qword [len]
        mov     rsi, hello              ; source string
        mov     rdi, hello              ; destination string
        cld                             ; direction from left to right

L2:
        lodsb                           ; load string byte
        cmp     al, 'a'                 ; if al < a
        jb      L4
        cmp     al, 'z'                 ; if al > z
        ja      L4
    
        ; transfer to upper case
        ; 65 A 0100 0001
        ; 97 a 0110 0001
        ; sub    al, 0x20
        and     al, 11011111b

L4:
        stosb                           ; store byte at address rdi to al
        loop    L2

        ; print
        mov     rcx, fmt
        mov     rdx, hello
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret

; ---------------------- Output ----------------------
; result: HELLO WORLD