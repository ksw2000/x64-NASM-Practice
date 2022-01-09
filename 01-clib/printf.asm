;-----------------------------------------------------------------
; An example for using clib printf() in NASM
;
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcrt.dll
; 
; Run: (command line)
; chcp 65001
; {filename}.exe
;
; If the output is garbled:
; https://stackoverflow.com/questions/57131654/using-utf-8-encoding-chcp-65001-in-command-prompt-windows-powershell-window
; 
; Reference:
; https://cs.lmu.edu/~ray/notes/nasmtutorial/
;-----------------------------------------------------------------
        global  main
        extern  printf                  ; clib function you want to call

        section .data                   ; initialized data
msg:    db      'Hello World 是在哈囉', 0xd, 0xa, 0
        ; db (define byte)              8 bits
        ; dw (define word)             16 bits
        ; dd (define double word)      32 bits
        ; dq (define quad word)        64 bits
msg2:   db      '%d %d %d %d %d', 0
        section .text                   ; main program
main:
        mov     rcx, msg
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; printf("%d %d %d %d %d", 1, 2, 3, 4, 5)
        mov     rcx, msg2
        mov     rdx, 1
        mov     r8, 2
        mov     r9, 3
        push    5
        push    4
        sub     rsp, 32
        call    printf
        ; stack:
        ; rsp -> | msg2 (rcx) |  [0]
        ;        |    1 (rdx) |  [8]
        ;        |    2 (r8)  |  [16]
        ;        |    3 (r9)  |  [24]
        ;        |    4       |  [32]
        ;        |    5       |  [40]
        add     rsp, 48                 ; 32+8+8 = 48
        ret

; ---------------------- Output ----------------------
; Hello World 是在哈囉
; 1 2 3 4 5
