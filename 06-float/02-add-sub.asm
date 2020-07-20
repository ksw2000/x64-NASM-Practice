EXTERN printf
SECTION .data
    a       dq      1.5
    b       dq      3.5
    fmt     db      '%4.1lf + %4.1lf = %4.1lf', 0xd, 0xa, 0
    fmt2    db      '%4.1lf - %4.1lf = %4.1lf', 0xd, 0xa, 0
SECTION .bss
sum     resq    1
SECTION .text
start:
    FINIT
    FLD     qword [a]
    FADD    qword [b]
    FSTP    qword [sum]

    mov     rcx, fmt
    mov     rdx, qword [a]
    mov     r8, qword [b]
    mov     r9, qword [sum]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    FLD     qword [a]
    FSUB    qword [b]
    FSTP    qword [sum]

    mov     rcx, fmt2
    mov     rdx, qword [a]
    mov     r8, qword [b]
    mov     r9, qword [sum]
    sub     rsp, 32
    call    printf
    add     rsp, 32
    ret
