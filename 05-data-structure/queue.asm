EXTERN printf, scanf
SECTION .data
    msg     db  'keyin number, 0 end: ', 0
    input   db  '%I64d', 0
    fmt     db  '[%I64d] ', 0
SECTION .bss
head    resq    1
tail    resq    1
data    resq    100
link    resq    100
num     resq    1

SECTION .text
start:
    mov     rsi, 0
    mov     qword [head], rsi
    mov     qword [tail], rsi
    mov     qword [data], rsi
    mov     qword [link], rsi

L2:
    mov     rcx, msg
    sub     rsp, 32
    call    printf
    add     rsp, 32

    mov     rcx, input
    mov     rdx, num
    sub     rsp, 32
    call    scanf
    add     rsp, 32

    cmp     qword [num], 0
    je      L6

L4:
    add     rsi, 8
    mov     rax, qword [num]
    mov     qword [data+rsi], rax
    mov     qword [link+rsi], 0
    mov     rdi, qword [tail]           ; rdi = 尾節點索引值
    mov     qword [link+rdi], rsi       ; 原尾節點鏈欄值 = RSI
    mov     qword [tail], rsi
    jmp     L2

L6:
    mov     rbx, qword [head]            ; rbx = 頭節點索引值
    mov     rbp, qword [link+rbx]        ; rbp = 頭節點

L8:
    mov     rcx, fmt
    mov     rdx, [data+rbp]
    sub     rsp, 32
    call    printf
    add     rsp, 32
    mov     rbp, [link+rbp]              ; rbp = 下個節點索引值
    cmp     rbp, 0
    jnz     L8
