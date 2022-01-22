; -------------------------------------------------------
; 2021/12/29
; calculate pi by Monte Carlo method
; 
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcrt.dll
; -------------------------------------------------------

        global  main
        extern  printf
        extern  rand
        extern  srand
        extern  time

        section .data
fmtResult:
        db      "4 * %d / %d = %lf", 0xa, 0xd, 0
randMax:
        dq      32767
num:    dq      1000000000
taketime:
        db      "took %ds", 0
        section .bss
tmp1:   resq    1
elapsed:
        resd    1
        section .text
main:
        ; use time() as seed
        xor     rcx, rcx
        sub     rsp, 32
        call    time
        add     rsp, 32
        mov     dword[elapsed], eax

        ; set seed by srand()
        mov     rcx, rax
        sub     rsp, 32
        call    srand
        add     rsp, 32

        mov     r12, [num]          ; r12 for looping
        xor     r13, r13            ; r13 is the number of all points in circle
        
        finit                       ; initialize FPU
        fld1                        ; push 1 into stack
        fild    qword[randMax]      ; push RAND_MAX into stack
.l1:
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
        fcomi   st0, st3            ; if st0 > 1
        fstp    st0                 ; pop stack
        fstp    st0                 ; pop stack
        ja      main.skip
        inc     r13                 ; if st0 <= 1 r13++
.skip:
        dec     r12
        cmp     r12, 0
        jne     main.l1

        ; calculate pi
        mov     rcx, r13            ; rcx = r13
        shl     rcx, 2              ; rcx = rcx * 4
        mov     qword [tmp1], rcx   ; tmp1 = rcx
        fild    qword [tmp1]        ; push rcx to stack (the number of points in circle)
        fild    qword [num]         ; push num to stack
        fdiv                        ; st0 = st1 / st0
        fstp    qword [tmp1]

        xor     rcx, rcx
        sub     rsp, 32
        call    time
        add     rsp, 32
        sub     eax, dword[elapsed]
        mov     dword[elapsed], eax

        ; print result
        mov     rcx, fmtResult
        mov     rdx, r13
        mov     r8, [num]
        mov     r9, [tmp1]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; print time
        mov     rcx, taketime
        xor     rdx, rdx
        mov     edx, dword[elapsed]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ret

; ---------------------- Output ----------------------
; 4 * 785381279 / 1000000000 = 3.141525
; took 48s