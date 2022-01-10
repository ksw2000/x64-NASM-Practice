;--------------------------------------------------------
; An example of changing control word in FPU.
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
fmt:    db      'control word = %04I64xH', 0xd, 0xa, 0
fmt2:   db      '17.5 after rounded = %I64d', 0xd, 0xa, 0
fmt3:   db      '17.5 not   rounded = %I64d', 0xd, 0xa, 0
f:      dq      17.5
        section .bss
n:      resq    1
ctrlword:
        resw    1
        section .text
main:
        ; finit
        ; control
        ; |15 14 13| 12| 11 10| 9 8| 7 6| 5| 4| 3| 2| 1| 0|
        ; |reserved|  Y|    RC|  PC| RES|PM|UM|OM|ZM|DM|IM|
        ; | 0  0  0|  0|  0  0| 1 1| 0 1| 1| 1| 1| 1| 1| 1|
        ;
        ; RC = 0 0
        ; Rounded result is the closest to the infinitely precise result.
        ; If two values are equally close, the result is the even value
        ; (that is, the one with the least-significant bit of zero).
        ;
        ; RC = 0 1
        ; Rounded result is closest to but no greater than the infinitely precise result.
        ;
        ; RC = 1 0
        ; Rounded result is closest to but no less than the infinitely precise result.
        ;
        ; RC = 1 1
        ; Rounded result is closest to but no greater in absolute value than the infinitely precise result.
        ;
        ; https://xem.github.io/minix86/manual/intel-x86-and-64-manual-vol1/o_7281d5ea06a5b67a-102.html
        ;
        ;
        ; FSTW: Store FPU control word to m2byte after checking for pending unmasked 
        ; floating-point exceptions.
part1:                                  ; use original control word
        finit
        fstcw   word [ctrlword]         ; get x87 FPU control word
        xor     rax, rax
        mov     ax, word [ctrlword]     ; ax = ctrlword

        ; printf(fmt, rax)
        mov     rcx, fmt
        mov     rdx, rax
        sub     rsp, 32
        call    printf
        add     rsp, 32

        fld     qword [f]               ; st0 = f
        fistp   qword [n]               ; store integer and pop

        ; printf(fmt2, n)
        mov     rcx, fmt2
        mov     rdx, qword [n]
        sub     rsp, 32
        call    printf
        add     rsp, 32
part2:                                  ; set control word by ourself
        xor     rax, rax
        mov     ax, word [ctrlword]
        and     rax, 03ffH              ; clear rc to 00
        or      rax, 0400H              ; set   rc to 01
        mov     word [ctrlword], ax
        fldcw   word [ctrlword]         ; set the control word

        mov     rcx, fmt                ; print the control word
        mov     rdx, rax
        sub     rsp, 32
        call    printf
        add     rsp, 32

        fld     qword [f]               ; st0 = f
        fistp   qword [n]               ; store integer and pop

        ; printf(fmt2, n)
        mov     rcx, fmt2
        mov     rdx, qword [n]
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret

; ---------------------- Output ----------------------
; control word = 037fH
; 17.5 after rounded = 18
; control word = 077fH
; 17.5 after rounded = 17