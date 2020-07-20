EXTERN printf, strlen
SECTION .data
    hello  db 'Hello World', 0
    fmt    db 'result: %s', 0xd, 0xa, 0

SECTION .bss
len    RESQ    1

SECTION .text
start:
    ; strlen
    mov    rcx, hello
    sub    rsp, 32
    call   strlen
    add    rsp, 32
    mov    qword [len], rax

    ; translate lower case to upper case
    mov    rcx, qword [len]
    mov    rsi, hello           ; source string
    mov    rdi, hello           ; destination string
    cld

L2:
    LODSB                       ; load string byte
    cmp    AL, 'a'
    jb     L4
    cmp    AL, 'z'
    ja     L4
    ; transfer to upper case
    ; 65 A 0100 0001
    ; 97 a 0110 0001
    sub    AL, 0x20
    ; and    AL, 11011111b
L4:
    STOSB                       ; store AL to RDI
    loop   L2                   ; Until rcx == 0

    ; print
    mov    rcx, fmt
    mov    rdx, hello
    sub    rsp, 32
    call   printf
    add    rsp, 32
