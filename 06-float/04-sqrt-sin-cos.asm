EXTERN printf
SECTION .data
    title   db  '     x    x*x     sqrt     sinx      cosx', 0xd, 0xa
            db  '-------------------------------------------', 0xd, 0xa, 0
    fmt     db  '%6.2f %6.2f   %6.4f   %6.4f   %+6.4f', 0xd, 0xa, 0
    delta   dq  0.1
    num     dq  1.0
SECTION .bss
    square   resq    1
    sqrt     resq    1
    sin      resq    1
    cos      resq    1
SECTION .text
start:
    mov     rcx, title
    sub     rsp, 32
    call    printf
    add     rsp, 32

    mov     r12, 21
    finit
calc:
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
    mov     r10, qword [sin]
    mov     r11, qword [cos]
    push    r11
    push    r10
    sub     rsp, 32
    call    printf
    add     rsp, 48

    fld     qword [num]
    fadd    qword [delta]
    fstp    qword [num]

    dec     r12
    cmp     r12, 0
    jne     calc
    ret
