;-------------------------------------------------------
; Example of using clib scanf() in NASM
;
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcrt.dll
;-------------------------------------------------------
        global  main
        extern  printf
        extern  scanf

        section .data
msg:    db      'keyin a dword int:', 0
msg2:   db      0xd, 0xa, 'output...' , 0
fmt:    db      '%d', 0
fmt2:   db      'you input %d', 0

        section .bss
in:     resd    1

        section .text
main:
        ; printf(msg)
        mov     rcx, msg
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; scanf(fmt, &in)
        mov     rcx, fmt
        mov     rdx, in
        sub     rsp, 32
        call    scanf
        add     rsp, 32

        ; printf(fmt2, in)
        sub     rsp, 32
        mov     rcx, fmt2
        mov     rdx, [in]
        call    printf
        add     rsp, 32
        ret