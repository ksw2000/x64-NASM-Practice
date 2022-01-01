;--------------------------------------------------------
; Example of using custom function, factorial, in NASM
;
; Assemble:t
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcr.dll
;-------------------------------------------------------

        global  main
        extern  printf
        extern  scanf

        section .data
request:
        db      'please input an integer: ', 0
inFmt:  db      '%d', 0
resultStr:
        db      '%d! = %d', 0

        section .bss
num:    resb    1

        section .text

        ; input: rcx
        ; return: rbx
factorial:
        xor     rbx, rbx
        mov     rbx, 1

.fac:
        imul    rbx, rcx
        loop    factorial.fac
        ret

main:
        ; printf: please input an integer
        mov     rcx, request
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; scanf
        mov     rcx, inFmt
        mov     rdx, num
        sub     rsp, 32
        call    scanf
        add     rsp, 32

        mov     rcx, [num]
        call    factorial

        ; printf
        mov     rcx, resultStr
        mov     rdx, [num]
        mov     r8, rbx
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret

; please input an integer: 5
; 5! = 120