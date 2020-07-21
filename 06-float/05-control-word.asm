EXTERN printf
SECTION .data
    fmt     db  'control word = %04I64xH', 0xd, 0xa, 0
    fmt2    db  '17.5 after rounded = %I64d', 0xd, 0xa, 0
    fmt3    db  '17.5 not   rounded = %I64d', 0xd, 0xa, 0
    f       dq  17.5
SECTION .bss
n           resq 1
ctrlword    resw 1
SECTION .text
start:
    ; FINIT
    ; control
    ; |15 14 13| 12| 11 10| 9 8| 7 6| 5| 4| 3| 2| 1| 0|
    ; |reserved|  Y|    RC|  PC| RES|PM|UM|OM|ZM|DM|IM|
    ;   0  0  0   0   0  0  1 1  0 1  1  1  1  1  1  1
    ;
    ; RC = 0 0
    ; Rounded result is the closest to the infinitely precise result.
    ; If two values are equally close, the result is the even value
    ; (that is, the one with the least-significant bit of zero).
    ;
    ; RC = 0 1
    ; Rounded result is closest to but no greater than the infinitely precise result.
    ;
    ; RC = 1 0
    ; Rounded result is closest to but no less than the infinitely precise result.
    ;
    ; RC = 1 1
    ; Rounded result is closest to but no greater in absolute value than the infinitely precise result.
    ;
    ; https://xem.github.io/minix86/manual/intel-x86-and-64-manual-vol1/o_7281d5ea06a5b67a-102.html
    finit
    fstcw   word [ctrlword]         ; get x87 FPU control word
    xor     rax, rax
    mov     ax, word [ctrlword]

    mov     rcx, fmt                ; print the control word
    mov     rdx, rax
    sub     rsp, 32
    call    printf
    add     rsp, 32

    fld     qword [f]
    fistp   qword [n]
    mov     rcx, fmt2
    mov     rdx, qword [n]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    xor     rax, rax
    mov     ax, word [ctrlword]
    and     rax, 03ffH              ; clear rc to 00
    or      rax, 0400H              ; set   rc to 01
    mov     word [ctrlword], ax
    fldcw   word [ctrlword]         ; set the control word

    mov     rcx, fmt                ; print the control word
    mov     rdx, rax
    sub     rsp, 32
    call    printf
    add     rsp, 32

    fld     qword [f]
    fistp   qword [n]
    mov     rcx, fmt2
    mov     rdx, qword [n]
    sub     rsp, 32
    call    printf
    add     rsp, 32
    ret
