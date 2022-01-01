;--------------------------------------------------------
; This is a practice of using strlen()
; 
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcrt.dll
;--------------------------------------------------------

        global  main
        extern  printf
        extern  strlen

        section .data
starstr:
        times   16 db '*'
        db      0
fmt:    db      0xd, 0xa, 'strlen: %d', 0
        section .bss
len:    resq 1
        section .text
main:
        ; print string
        mov     rcx, starstr
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; call strlen
        ; strlen(starstr)
        mov     rcx, starstr
        sub     rsp, 32
        call    strlen
        add     rsp, 32
        mov     qword[len], rax

        ; print string length
        mov     rcx, fmt
        mov     rdx, [len]
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret

; ---------------------- Output ----------------------
; ****************
; strlen: 16