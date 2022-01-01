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
;
; Reference:
; https://cs.lmu.edu/~ray/notes/nasmtutorial/
;-----------------------------------------------------------------
        global  main
        extern  printf                  ; clib function you want to call

        section .data                   ; initialized data
msg:    db      'Hello World 是在哈囉', 0
        ; db (define byte)              8 bits
        ; dw (define word)             16 bits
        ; dd (define double word)      32 bits
        ; dq (define quad word)        64 bits

        section .text                   ; main program
main:
        mov    rcx, msg
        sub    rsp, 32
        call   printf
        add    rsp, 32
        ret