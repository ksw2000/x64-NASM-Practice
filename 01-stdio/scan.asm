EXTERN printf, scanf

SECTION .data
    msg    DB   'keyin a dword int:', 0
    msg2   DB   0xd, 0xa, 'output...' , 0
    fmt    DB   '%d', 0
    fmt2   DB   'you input %d', 0

SECTION .bss
    in:    RESD 1

SECTION .text
start:
    ; 印出 msg
    push   rcx
    mov    rcx, msg
    sub    rsp, 32
    call   printf
    add    rsp, 32
    pop    rcx

    ; 輸入
    push   rcx
    push   rdx
    mov    rcx, fmt  ;格式參數位址
    mov    rdx, in   ;參數輸入位址
    sub    rsp, 32
    call   scanf
    add    rsp, 32
    pop    rdx
    pop    rcx

    ; 印出 in
    push   rcx
    push   rdx
    sub    rsp, 32
    mov    rcx, fmt2
    mov    rdx, [in]
    call   printf
    add    rsp, 32
    pop    rdx
    pop    rcx
