; this is a practice for use load string byte and store
; split float number
; e.g. 3.14 to 3 and 14
EXTERN scanf, printf, strlen
SECTION .data
    msg     db  'please input an float number: ', 0
    input   db  '%s', 0
    msgErr  db  'there is an invalid character', 0
    result  db  '%s & %s', 0
SECTION .bss
numStr  resb 512
left    resb 256
right   resb 256
SECTION .text
start:
    ; print hint
    mov     rcx, msg
    sub     rsp, 32
    call    printf
    add     rsp, 32

    ; scan
    mov     rcx, input
    mov     rdx, numStr
    sub     rsp, 32
    call    scanf
    add     rsp, 32

    ; get string len
    mov     rcx, numStr
    sub     rsp, 32
    call    strlen
    add     rsp, 32

    ; init for left
    mov     rcx, rax
    mov     rsi, numStr
    mov     rdi, left
    cld

L1:
    lodsb
    cmp     al, '.'
    je      L2
    cmp     al, 0
    je      L3
    cmp     al, '0'
    jb      err
    cmp     al, '9'
    ja      err
    stosb
    loop    L1

L2:
    ; init for right
    mov     rdi, right
    jmp     L1

L3:
    mov     rcx, result
    mov     rdx, left
    mov     r8, right
    sub     rsp, 32
    call    printf
    add     rsp, 32
    ret

err:
    mov     rcx, msgErr
    sub     rsp, 32
    call    printf
    add     rsp, 32
    ret
