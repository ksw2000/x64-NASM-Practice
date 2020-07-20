EXTERN printf
SECTION .data
    msg     db  'array: ', 0
    arr     dd  18, 29, 32, 44, 55, 60
    len     db  6
    prtnum  db  '[%2d] ', 0
    prtsum  db  0xd, 0xa, 'sum is: %d', 0
SECTION .bss

SECTION .text
start:
    mov     rcx, msg
    sub     rsp, 32
    call    printf
    add     rsp  , 32

    movsx   rcx, byte [len]
    xor     r12d, r12d
L1:
    push    rcx
    mov     rcx, prtnum
    movsx   rdx,  dword [arr + rsi]
    add     r12d, dword [arr + rsi]
    sub     rsp, 32
    call    printf
    add     rsp, 32
    pop     rcx
    add     rsi, 4
    loop    L1

    ; printf sum
    mov     rcx, prtsum
    movsx   rdx, r12d
    sub     rsp, 32
    call    printf
    add     rsp, 32
    ret
