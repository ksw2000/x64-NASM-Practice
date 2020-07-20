EXTERN  printf, scanf
SECTION .data
    request     db  'please input an integer: ', 0
    inFmt       db  '%d', 0
    resultStr   db  '%d! = %d', 0

SECTION .bss
num     RESB    1

SECTION .text
;input: rcx , return: rbx
factorial:
    xor     rbx,    rbx
    mov     rbx,    1
.Fac:
    IMUL    rbx,    rcx
    LOOP    factorial.Fac
    ret

start:
    ;printf: please input an integer
    mov     rcx,    request
    sub     rsp,    32
    call    printf
    add     rsp,    32

    ;scanf
    mov     rcx,    inFmt
    mov     rdx,    num
    sub     rsp,    32
    call    scanf
    add     rsp,    32

    mov     rcx,    [num]
    call    factorial

    ;printf
    mov     rcx,    resultStr
    mov     rdx,    [num]
    mov     r8,     rbx
    sub     rsp,    32
    call    printf
    add     rsp,    32
