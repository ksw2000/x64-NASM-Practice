; without feof
EXTERN printf, fopen, fgetc, fclose
SECTION .data
    path    db '..\\demo.txt', 0
    mode    db 'r', 0
    fmt     db '%c', 0
    err     db 'can not open demo.txt', 0xd, 0xa, 0

SECTION .bss
f       resq 1 ; qword [f] = FILE*
char    resq 1 ; record fgetc's c
SECTION .text
start:
    ; fopen(path, mode)
    ; return rax
    mov     rcx, path
    mov     rdx, mode
    sub     rsp, 32
    call    fopen
    add     rsp, 32
    mov     qword [f], rax
    cmp     rax, 0
    je      fopenNil

L1:
    ; use fgetc to read
    mov     rcx, [f]
    sub     rsp, 32
    call    fgetc
    add     rsp, 32

    cmp     eax, -1 ; if eax == EOF goto close
    jz      close

    ; print
    mov     rcx, fmt
    mov     rdx, rax
    sub     rsp, 32
    call    printf
    add     rsp, 32
    jmp     L1

close:
    mov     rcx, [f]
    sub     rsp, 32
    call    fclose
    add     rsp, 32
    ret

fopenNil:
    mov     rcx, err
    sub     rsp, 32
    call    printf
    add     rsp, 32
    ret
