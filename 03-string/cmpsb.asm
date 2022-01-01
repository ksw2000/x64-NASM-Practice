;--------------------------------------------------------
; compare string bytes
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
fmt:    db      'str1 len: %d', 0xd, 0xa, 0
str1:   db      'Good Morning', 0
str2:   db      'Good Night', 0
fmtE:   db      'str1 is equal to str2', 0
fmtNE:  db      'str1 is not equal to str2, from %d', 0

        section .bss
len:    resq    1
pos:    resb    1

        section .text
main:
        ; calculate the length of str1
        mov     rcx, str1
        sub     rsp, 32
        call    strlen
        add     rsp, 32
        mov     qword [len], rax

        ; print length
        mov     rcx, fmt
        mov     rdx, qword [len]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; compare
        mov     rcx, qword[len]
        mov     rsi, str1
        mov     rdi, str2
        cld                             ; direction from left to right
        mov     qword [pos], 0
.LCMP:
        cmpsb                           ; compare string bytes
        pushf                           ; push flag registers
        inc     qword [pos]             ; increase pos
        popf                            ; pop flag registers
        loope   main.LCMP

        cmp     rcx, 0
        je      main.ifEqual
        mov     rcx, fmtNE              ; prepare printf(fmtNE)
        mov     rdx, qword [pos]
        dec     rdx
        jmp     main.endIf
.ifEqual:
        mov     rcx, fmtE               ; prepare printf(fmtE)

.endIf:
        sub     rsp, 32
        call    printf
        add     rsp, 32

; ---------------------- Output ----------------------
; str1 len: 12
; str1 is not equal to str2, from 5