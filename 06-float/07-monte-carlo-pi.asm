; ----------------------------------
; 2021/12/29
; calculate pi by Monte Carlo method
; 
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; ----------------------------------

    global main
    extern printf
    extern rand
    extern srand
    extern time

section .data
    fmtResult   db "4 * %d / %d = %lf", 0xa, 0xd, 0
    randMax     dq 32767
    num         dq 100000000

section .bss
    tmp1:       resq 1

section .text
main:
    ; use time() as seed
    xor     rcx, rcx
    sub     rsp, 32
    call    time
    add     rsp, 32

    ; set seed by srand()
    mov     rcx, rax
    sub     rsp, 32
    call    srand
    add     rsp, 32

    mov     r14, [num]  ; r14 for looping
    xor     r15, r15    ; r15 is the number of all points in circle
    
    finit                       ; initialize FPU
    fld1                        ; push 1 into stack
    fild    qword[randMax]      ; push RAND_MAX into stack
l1:
    ; call rand()
    sub     rsp, 32
    call    rand
    add     rsp, 32
    mov     qword[tmp1], rax

    ; mapping rand number to [0, 1)
    fild    qword[tmp1]         ; st0 = rand()
    fdiv    st0, st1            ; st0 = st0 / RAND_MAX
    fmul    st0, st0            ; st0 = st0 * st0

    ; call rand() again
    sub     rsp, 32
    call    rand
    add     rsp, 32
    mov     qword[tmp1], rax

    ; mapping rand number to [0, 1)
    fild    qword[tmp1]         ; st1 = st0
                                ; st0 = rand()
    fdiv    st0, st2            ; st0 = st0 / RAND_MAX
    fmul    st0, st0            ; st0 = st0 * st0
    fadd    st0, st1            ; st0 = st0 + st1
    fcomi   st0, st3            ; if st0 > 1 ?
    fstp    st0                 ; pop stack
    fstp    st0                 ; pop stack
    ja      skip
    inc     r15                 ; if st0 <= 1 r15++
skip:
    dec     r14
    cmp     r14, 0
    jne     l1

    ; calculate pi
    mov     rcx, r15            ; rcx = r15
    shl     rcx, 2              ; rcx = rcx * 4
    mov     qword [tmp1], rcx   ; tmp1 = rcx
    fild    qword [tmp1]        ; push rcx to stack (the number of points in circle)
    fild    qword [num]         ; push num to stack
    fdiv                        ; st0 = st1 / st0
    fstp    qword [tmp1]

    ; print result
    mov     rcx, fmtResult
    mov     rdx, r15
    mov     r8, [num]
    mov     r9, [tmp1]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    ret