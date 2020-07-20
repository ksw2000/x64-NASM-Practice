; move string
EXTERN printf
SECTION .data
    lenpat  DQ 4
    len     DQ 44
    strpat  DB '*--*'
            TIMES 40 DB ' '
            DB 0
    fmt     DB 'result %s', 0
SECTION .bss

SECTION .text
start:
    mov    rcx, [len]
    sub    rcx, QWORD [lenpat]
    mov    rsi, strpat          ;source string
    mov    rdi, strpat          ;destination string
    add    rdi, qword [lenpat]
    cld                         ;direction from left to right
    rep    movsb

    ; print result
    mov    rcx, fmt
    mov    rdx, strpat
    sub    rsp, 32
    call   printf
    add    rsp, 32
