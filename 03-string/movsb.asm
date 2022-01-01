;--------------------------------------------------------
; move string byte
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

        section .data
lenpat: dq      4
len:    dq      44
strpat: db      '*--*'
        times   40 db ' '
        db      0
befFmt: db      'before: %s', 0xa, 0xd, 0
aftFmt: db      'after:  %s', 0xa, 0xd, 0

        section .text
main:
        ; print original string
        mov     rcx, befFmt
        mov     rdx, strpat
        sub     rsp, 32
        call    printf
        add     rsp, 32

        mov     rcx, [len]
        sub     rcx, qword [lenpat]
        mov     rsi, strpat          ; source string
        mov     rdi, strpat          ; destination string
        add     rdi, qword [lenpat]
        cld                          ; direction from left to right

        rep                          ; rep repeat rcx times
        movsb                        ; movsb moves one byte from address in rsi to address in rdi

        ; print result
        mov     rcx, aftFmt
        mov     rdx, strpat
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret

; ---------------------- Output ----------------------
; before: *--*
; after:  *--**--**--**--**--**--**--**--**--**--**--*