;--------------------------------------------------------
; Example of using fsqrt, fsin, fcos
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
title:  db  '     x    x*x     sqrt     sinx      cosx', 0xd, 0xa
        db  '-------------------------------------------', 0xd, 0xa, 0
fmt:    db  '%6.1f %6.2f   %6.4f   %6.4f   %+6.4f', 0xd, 0xa, 0
delta:  dq  0.1
num:    dq  1.0
        section .bss
square:  resq    1
sqrt:    resq    1
sin:     resq    1
cos:     resq    1
        section .text
main:
        ; printf(title)
        mov     rcx, title
        sub     rsp, 32
        call    printf
        add     rsp, 32

        mov     r12, 21         ; r12 for looping
        finit
.calc:
        fld     qword [num]
        fld     qword [num]
        fld     qword [num]
        fld     qword [num]
        fmul    qword [num]
        fstp    qword [square]
        fsqrt
        fstp    qword [sqrt]
        fsin
        fstp    qword [sin]
        fcos
        fstp    qword [cos]

        mov     rcx, fmt
        mov     rdx, qword [num]
        mov     r8, qword [square]
        mov     r9, qword [sqrt]
        push    qword [cos]
        push    qword [sin]
        sub     rsp, 32
        call    printf
        add     rsp, 48

        fld     qword [num]
        fadd    qword [delta]
        fstp    qword [num]

        dec     r12
        jnz     main.calc
        ret

;      x    x*x     sqrt     sinx      cosx
; -------------------------------------------
;    1.0   1.00   1.0000   0.8415   +0.5403
;    1.1   1.21   1.0488   0.8912   +0.4536
;    1.2   1.44   1.0954   0.9320   +0.3624
;    1.3   1.69   1.1402   0.9636   +0.2675
;    1.4   1.96   1.1832   0.9854   +0.1700
;    1.5   2.25   1.2247   0.9975   +0.0707
;    1.6   2.56   1.2649   0.9996   -0.0292
;    1.7   2.89   1.3038   0.9917   -0.1288
;    1.8   3.24   1.3416   0.9738   -0.2272
;    1.9   3.61   1.3784   0.9463   -0.3233
;    2.0   4.00   1.4142   0.9093   -0.4161
;    2.1   4.41   1.4491   0.8632   -0.5048
;    2.2   4.84   1.4832   0.8085   -0.5885
;    2.3   5.29   1.5166   0.7457   -0.6663
;    2.4   5.76   1.5492   0.6755   -0.7374
;    2.5   6.25   1.5811   0.5985   -0.8011
;    2.6   6.76   1.6125   0.5155   -0.8569
;    2.7   7.29   1.6432   0.4274   -0.9041
;    2.8   7.84   1.6733   0.3350   -0.9422
;    2.9   8.41   1.7029   0.2392   -0.9710
;    3.0   9.00   1.7321   0.1411   -0.9900