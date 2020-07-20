;compare string byte
EXTERN printf, strlen
SECTION .data
fmt    db     'str1 len: %d', 0xd, 0xa, 0
str1   db     'Good Morning', 0
str2   db     'Good Night', 0
;str2   db     'Good Morning', 0
fmtE   db     'str1 is equal to str2', 0
fmtNE  db     'str1 is not equal to str2, from %d', 0

SECTION .bss
len    resq   1
pos    resb   1

SECTION .text
start:
    ; calculate the length of str1
    mov    rcx, str1
    sub    rsp, 32
    call   strlen
    add    rsp, 32
    mov    qword [len], rax

    ; print length
    mov    rcx, fmt
    mov    rdx, qword [len]
    sub    rsp, 32
    call   printf
    add    rsp, 32

    ; compare
    mov    rcx, qword[len]
    mov    rsi, str1
    mov    rdi, str2
    cld                     ;direction from left to right
    mov    qword [pos], 0
LCMP:
    cmpsb
    pushf                   ;push flag registers
    inc    qword [pos]      ;increase pos
    popf                    ;pop flag registers
    loope  LCMP

    cmp    rcx, 0
    JE     E
    mov    rcx, fmtNE
    mov    rdx, qword [pos]
    dec    rdx
    jmp    ENDIF
E:
    mov    rcx, fmtE

ENDIF:
    sub    rsp, 32
    call   printf
    add    rsp, 32
