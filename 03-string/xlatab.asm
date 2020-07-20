; 於 RBX 給定陣列
; 於 AL 給定偏移量
; 偏移結果回傳值在 AL
EXTERN printf, scanf
SECTION .data
tab     db '0123456789abcdef', 0
msg     db 'type a number 0-15: ', 0
err     db 'error', 0
input   db '%d', 0
msgans  db '%c', 0

SECTION .bss
num resb 1

SECTION .text
start:
    mov     rcx, msg
    sub     rsp, 32
    call    printf
    add     rsp, 32

    mov     rcx, input
    mov     rdx, num
    sub     rsp, 32
    call    scanf
    add     rsp, 32

    cmp     qword [num], 15
    ja      error
    cmp     qword [num], 0
    jb      error

    mov     rbx, tab             ; offset address
    mov     rax, [num]           ; AL: index
    xlatb
    ; al is answer

    mov     rcx, msgans
    movzx   rdx, al
    sub     rsp, 32
    call    printf
    add     rsp, 32
    ret
error:
    mov     rcx, err
    sub     rsp, 32
    call    printf
    add     rsp, 32
    ret
