;----------------------------------------
; Assemble:
; nasm -f win64 {filename}.asm
; Link:
; gcc {filename}.o -o {filename}.exe
;
; Reference:
; https://cs.lmu.edu/~ray/notes/nasmtutorial/
;----------------------------------------

    global main
    extern printf

    section .text
main:
    mov rcx, msg
    sub rsp, 32
    call printf
    add rsp, 32


    section .data
msg: db 'Hello World 是在哈囉', 0
