;--------------------------------------------------------
; Example of using custom function in NASM
;
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcrt.dll
;-------------------------------------------------------

        global  main
        extern  scanf
        extern  printf

        section .data
msg:    db      'Please input 3 integer: ', 0
infmt:  db      '%d %d %d', 0
numfmt: db      '%d + %d + %d = %d', 0xa, 0xd, 0
show:   db      '%d', 0

        section .bss
a:      resd    1
b:      resd    1
c:      resd    1

        section .text
main:
        ; printf(msg)
        mov     rcx, msg
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; scanf(infmt, &a, &b, &c)
        mov     rcx, infmt
        mov     rdx, a
        mov     r8, b
        mov     r9, c
        sub     rsp, 32
        call    scanf
        add     rsp, 32

        ; call add3
        mov     rcx, [c]
        mov     rdx, [a]
        mov     r8, [b]
        call    add3
        ; return value is in rax

        ; printf(numfmt, a, b, c, rax)
        push    rax
        mov     r9, [c]
        mov     r8, [b]
        mov     rdx, [a]
        mov     rcx, numfmt
        sub     rsp, 32
        call    printf
        
        ; stack now
        ; numfmt    <- rsp
        ; [a]       <- rsp+8
        ; [b]       <- rsp+16
        ; [c]       <- rsp+24
        ; rax       <- rsp+32

        add     rsp, 40
        ret

add3:
        xor     rax, rax
        add     rax, rcx
        add     rax, rdx
        add     rax, r8
        ret

; ---------------------- Output ----------------------
; Please input 3 integer: 1 2 3
; 1 + 2 + 3 = 6