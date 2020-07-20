EXTERN scanf, printf

SECTION .data
    msg     db      'Please input 3 integer: ', 0
    infmt   db      '%d %d %d', 0
    numfmt  db      '%d + %d + %d = %d', 0

SECTION .bss
a   RESD    1
b   RESD    1
c   RESD    1

SECTION .text
; use rcx, rdx, r8 and return answer is rbx
add3:
    xor     rbx,    rbx
    add     rbx,    rcx
    add     rbx,    rdx
    add     rbx,    r8
    ret

start:
    ;printf
    mov     rcx,    msg
    sub     rsp,    32
    call    printf
    add     rsp,    32

    ;scanf
    mov     rcx,    infmt
    mov     rdx,    a
    mov     r8,     b
    mov     r9,     c
    sub     rsp,    32
    call    scanf
    add     rsp,    32

    ;call add3
    mov     rcx,    [c]
    mov     rdx,    [a]
    mov     r8,     [b]
    call    add3

    ;printf
    push    rbx
    mov     rcx,    numfmt
    mov     rdx,    [a]
    mov     r8,     [b]
    mov     r9,     [c]
    sub     rsp,    32
    call    printf
    add     rsp,    40
    pop     rbx
