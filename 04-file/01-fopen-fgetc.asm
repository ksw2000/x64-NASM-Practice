EXTERN printf, fopen, fgetc, feof, fclose
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

    ; Note that: use [f] not f !!
    ; Note that: use [f] not f !!
    ; Note that: use [f] not f !!

    mov     rcx, [f]
    sub     rsp, 32
    call    fgetc
    add     rsp, 32
    mov     qword [char], rax

    ; use feof to check wheather here is eof
    mov     rcx, [f]
    sub     rsp, 32
    call    feof
    add     rsp, 32
    cmp     rax, 0
    jne     close   ; if rax is eof then jump to close

    ; print
    mov     rcx, fmt
    mov     rdx, qword [char]
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
