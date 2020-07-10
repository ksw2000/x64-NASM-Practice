EXTERN printf

SECTION .data
    msg DB 'Hello World 是在哈囉', 0

SECTION .text
start:
    mov    rcx, msg
    sub    rsp, 32
    call   printf
    add    rsp, 32
