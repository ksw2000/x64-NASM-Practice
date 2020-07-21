EXTERN printf, scanf
SECTION .data
    msg     db  'please input two floating number: ', 0
    inFmt   db  '%lf %lf', 0
    outFmt  db  'flag reg = %02I64xH', 0xd, 0xa, 0
    result  db  '%lf %s %lf', 0xd, 0xa,0
    gt      db  '>', 0
    lt      db  '<', 0
    eq      db  '=', 0
    newline db  0xd, 0xa, 0
SECTION .bss
a       resq    1
b       resq    1
flag    resq    1
op      resq    1
SECTION .text
start:
    ; status
    ; |15| 14| 13 12 11| 10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    ; |B | C3|  T O P  | C2|C1|C0|ES|SF|PE|UE|OE|ZE|DE|IE|
    ;
    ; Use FSTSW to copy FPU status word to CPU register (AH);
    ;
    ; Use SAHF (Store AH into Flags' AL)
    ; FPU C3 to CPU ZF
    ; FPU C2 to CPU PF
    ; FPU C1 to none
    ; FPU C0 to CPU CF
    ;
    ; FCOM
    ; if tos is smaller
    ; C0 = 1 C3 = 0
    ; if tos is bigger
    ; C0 = 0 C3 = 0
    ; if two are equal
    ; C0 = 0 C3 = 1

    mov     rcx, msg
    sub     rsp, 32
    call    printf
    add     rsp, 32

    mov     rcx, inFmt
    mov     rdx, a
    mov     r8, b
    sub     rsp, 32
    call    scanf
    add     rsp, 32

    finit
    fld     qword [a]
    fcom    qword [b]       ; a compare to b
    fstsw   ax              ; FPU flags to AH
    sahf                    ; AH to CPU flag' AL

    pushfq
    pop     qword [flag]

    mov     rcx, outFmt      ; pirint flag
    mov     rdx, qword [flag]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    test    byte [flag], 00000001B  ; test C0
    jnz     LESS                    ; If C0 = 1 goto less
    test    byte [flag], 01000000B  ; test C3
    jnz     EQUAL                   ; If C3 = 1 goto equal
    mov     qword[op], gt
    jmp     COMP_RESULT
LESS:
    mov     qword[op], lt
    jmp     COMP_RESULT
EQUAL:
    mov     qword[op], eq
COMP_RESULT:
    mov     rcx, result
    mov     rdx, qword [a]
    mov     r8, qword [op]
    mov     r9, qword [b]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    mov     rcx, newline
    sub     rsp, 32
    call    printf
    add     rsp, 32
    jmp     start
