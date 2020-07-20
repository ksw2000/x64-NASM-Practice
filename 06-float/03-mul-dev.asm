EXTERN printf
    fmt     db  '%4.1lf * %4.1lf = %.8lf', 0xd, 0xa, 0
    fmt2    db  '%4.1lf / %4.1lf = %.8lf', 0xd, 0xa, 0

SECTION .data
a   dq  1.5
b   dq  3.5
SECTION .bss
product     resq    1
quotient    resq    1
SECTION .text
start:
    FINIT
    FLD     qword [a]
    FMUL    qword [b]
    FSTP    qword [product]
    mov     rcx, fmt
    mov     rdx, qword [a]
    mov     r8, qword [b]
    mov     r9, qword [product]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    FLD     qword [a]
    FDIV    qword [b]
    FSTP    qword [quotient]
    mov     rcx, fmt2
    mov     rdx, qword [a]
    mov     r8, qword [b]
    mov     r9, qword [quotient]
    sub     rsp, 32
    call    printf
    add     rsp, 32
    ret
