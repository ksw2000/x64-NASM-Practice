EXTERN printf
SECTION .data
    a       dq  1.5
    b       dq  3.5
    c       dq  5.5
    d       dq  0.0

    fmt0    db  '%s %5.2lf', 0xd, 0xa, 0
    fmt1    db  '   %s %04I64xH', 0

    msg0    db  'after FINIT', 0xd, 0xa, 0
    msg1    db  'after pushing', 0
    msg2    db  'after poping', 0
    msgc    db  'control = ', 0
    msgs    db  'status = ', 0
    msgt    db  'tag = ', 0

    newline db  0xd, 0xa, 0

    control dd  0
    status  dd  0
    tag     dd  0

SECTION .bss
SECTION .text
start:
    finit                   ; initialize Floating-point Stack
    mov     rcx, msg0
    sub     rsp, 32
    call    printf
    add     rsp, 32

    call    getenv

    ;--------------------------------------;
    fld     qword [a]       ; load [a]

    mov     rcx, fmt0
    mov     rdx, msg1
    mov     r8, [a]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    call    getenv

    ;--------------------------------------;
    fld     qword [b]       ; load [b]

    mov     rcx, fmt0
    mov     rdx, msg1
    mov     r8, [b]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    call    getenv

    ;--------------------------------------;
    fld     qword [c]       ; load [c]

    mov     rcx, fmt0
    mov     rdx, msg1
    mov     r8, [c]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    call    getenv

    ;--------------------------------------;
    fstp    qword [d]       ; store TOS and pop

    mov     rcx, fmt0
    mov     rdx, msg2
    mov     r8, [d]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    call    getenv

    ;--------------------------------------;
    fstp    qword [d]       ; store TOS and pop

    mov     rcx, fmt0
    mov     rdx, msg2
    mov     r8, [d]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    call    getenv

    ;--------------------------------------;
    fstp    qword [d]       ; store TOS and pop

    mov     rcx, fmt0
    mov     rdx, msg2
    mov     r8, [d]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    call    getenv
    ret

getenv:
    fstenv  [control]       ; store environment to memory
                            ; control (16bits)
                            ; status  (16bits)
                            ; tag     (16bits)
    ; control
    ; |15 14 13| 12| 11 10| 9 8| 7 6| 5| 4| 3| 2| 1| 0|
    ; |reserved|  Y|    RC|  PC| RES|PM|UM|OM|ZM|DM|IM|
    ;
    ; status
    ; |15| 14| 13 12 11| 10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    ; |B | C3|  T O P  | C2|C1|C0|ES|SF|PE|UE|OE|ZE|DE|IE|
    ;
    ; tag
    ; |15 14|13 12|11 10|  9 8|  7 6|  5 4|  3 2|  1 0|
    ; | FPR7| FPR6| FPR5| FPR4| FPR3| FPR2| FPR1| FPR0|

    xor     rax, rax
    mov     ax, word [control]  ; 16bits

    mov     rcx, fmt1
    mov     rdx, msgc
    mov     r8, rax
    sub     rsp, 32
    call    printf              ; print 4-digit hex
    add     rsp, 32

    xor     rax, rax
    mov     ax, word [status]   ; 16bits
    mov     rcx, fmt1
    mov     rdx, msgs
    mov     r8, rax
    sub     rsp, 32
    call    printf              ; print 4-digit hex
    add     rsp, 32

    xor     rax, rax
    mov     ax, word [tag]      ; 16bits
    mov     rcx, fmt1
    mov     rdx, msgt
    mov     r8, rax
    sub     rsp, 32
    call    printf              ; print 4-digit hex
    add     rsp, 32

    mov     rcx, newline
    sub     rsp, 32
    call    printf
    add     rsp, 32

    ret
