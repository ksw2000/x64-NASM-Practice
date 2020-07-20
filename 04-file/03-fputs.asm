EXTERN printf, fopen, gets, strlen, fputs, fclose
SECTION .data
    msg     db 'input some text: ', 0
    path    db '..\\demo_write.txt',0
    mode    db 'w',0
    fmt     db 'success', 0xd, 0xa, 0
    err     db 'fopen error', 0

SECTION .bss
buf     resb 256
f       resw 1

SECTION .text
start:
    ; fopen (write)
    mov     rcx, path
    mov     rdx, mode
    sub     rsp, 32
    call    fopen
    add     rsp, 32
    mov     qword [f], rax
    cmp     rax, 0
    je      fopenNil

L1:
    ; print hint
    mov     rcx, msg
    sub     rsp, 32
    call    printf
    add     rsp, 32

    ; gets
    mov     rcx, buf
    sub     rsp, 32
    call    gets
    add     rsp, 32
    cmp     rax, 0  ; if get EOF rax == 0
    je      end     ; type ctrl+z is equal to EOF

    ; prepare
    ; insert 0xa 0 in the end of buf
    mov     rcx, buf
    sub     rsp, 32
    call    strlen
    add     rsp, 32 ; rax = string len
    mov     rbx, buf
    add     rbx, rax
    mov     byte [rbx], 0xa
    mov     byte [rbx + 1], 0x0

    ; fputs
    mov     rcx, buf
    mov     rdx, [f]
    sub     rsp, 32
    call    fputs
    add     rsp, 32

    ; print success
    mov     rcx, fmt
    sub     rsp, 32
    call    printf
    add     rsp, 32
    jmp     L1

end:
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
