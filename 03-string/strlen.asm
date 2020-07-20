EXTERN printf, strlen
SECTION .data
    starstr     TIMES 16  DB '*'
                DB 0
    fmt         DB 0xd, 0xa, 'strlen: %d', 0
SECTION .bss
len RESQ 1

SECTION .text
start:
    ; print string
    mov    rcx, starstr
    sub    rsp, 32
    call   printf
    add    rsp, 32

    ; calc string length
    mov    rcx, starstr
    sub    rsp, 32
    call   strlen
    add    rsp, 32
    mov    QWORD [len], rax

    ; print string length
    mov    rcx, fmt
    mov    rdx, [len]
    sub    rsp, 32
    call   printf
    add    rsp, 32
