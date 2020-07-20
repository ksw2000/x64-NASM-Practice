EXTERN  printf, scanf
SECTION .data
    top     dq 0
    msg     db 'keyin number, 0 end:', 0
    infmt   db '%I64d', 0
    fmt     db '%I64d ', 0
SECTION .bss
data    resq    100
link    resq    100
num     resq    1

SECTION .text
start:
    mov     rsi, 0
    mov     qword [top], rsi
L2:
    mov     rcx, msg
    sub     rsp, 32
    call printf
    add     rsp, 32
    mov     rcx, infmt
    mov     rdx, num
    sub     rsp, 32
    call scanf
    add     rsp, 32
    cmp     qword [num], 0
    je      L4

    add     rsi, 8
    mov     rbx, qword [top]
    mov     rax, qword [num]
    mov     qword [data + rsi], rax
    mov     qword [link + rsi], rbx
    mov     qword [top], rsi
    jmp     L2

L4:
    mov     rbp, [top]
L6:
    mov     rcx, fmt
    mov     rdx, [data + rbp]
    sub     rsp, 32
    call    printf
    add     rsp, 32
    mov     rbp, [link+rbp]
    cmp     rbp, 0
    jne     L6

    ret
