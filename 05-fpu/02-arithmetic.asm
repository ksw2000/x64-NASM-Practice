;--------------------------------------------------------
; fld
; fild
; fst, fstp
; fadd, fsub, fmul, fdiv
; 
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcrt.dll
;--------------------------------------------------------

        global  main
        extern  printf

        section .data
a:      dq      1.5
b:      dq      3.5
fmt:    db      '%4.1lf %c %4.1lf = %4.1lf', 0xd, 0xa, 0
op_add: db      '+'
op_sub: db      '-'  
op_mul: db      '*'
op_div: db      '/'
      
        section .bss
res:    resq    1
        section .text
main:
        finit                   ; Initialize Floating-Point Unit
        fld     qword [a]       ; st0 = a
        fadd    qword [b]       ; st0 = st0 + b
        fstp    qword [res]     ; res = st0
                                ; pop

        ; printf(fmt, a, '+', b, res)
        mov     rcx, fmt
        mov     rdx, qword [a]
        mov     r8, qword [op_add]
        mov     r9, qword [b]
        push    qword [res]
        sub     rsp, 32
        call    printf
        add     rsp, 40

        fld     qword [a]       ; st0 = a
        fsub    qword [b]       ; st0 = sto - b
        fstp    qword [res]     ; res = st0

        ; printf(fmt, a, '-', b, res)
        mov     rcx, fmt
        mov     rdx, qword [a]
        mov     r8, qword [op_sub]
        mov     r9, qword [b]
        push    qword [res]
        sub     rsp, 32
        call    printf
        add     rsp, 40

        fld     qword [a]       ; st0 = a
        fmul    qword [b]       ; st0 = st0 * b
        fstp    qword [res]     ; res = st0
                                ; pop

        ; printf(fmt, a, '*', b, res)
        mov     rcx, fmt
        mov     rdx, qword [a]
        mov     r8, qword [op_mul]
        mov     r9, qword [b]
        push    qword [res]
        sub     rsp, 32
        call    printf
        add     rsp, 40

        fld     qword [a]       ; st0 = a
        fdiv    qword [b]       ; st0 = st0 / a
        fstp    qword [res]
        
        ; printf(fmt, a, '/', b, res)
        mov     rcx, fmt
        mov     rdx, qword [a]
        mov     r8, qword [op_div]
        mov     r9, qword [b]
        push    qword [res]
        sub     rsp, 32
        call    printf
        add     rsp, 40

        ; another example
        push    2
        fild    qword [rsp]     ; load integer to FPU stack
        add     rsp, 8
        fld     qword [a]       ; st0 = a
        ; st0: a
        ; st1: 2.0
        fmul    st0, st1        ; st0 = st0 + st1
        fstp    qword [res]
        fstp    qword [b]
        
        ; printf(fmt, b, '*', a, res)
        mov     rcx, fmt
        mov     rdx, qword [b]
        mov     r8, qword [op_mul]
        mov     r9, qword [a]
        push    qword [res]
        sub     rsp, 32
        call    printf
        add     rsp, 40
        ret

; ---------------------- Output ----------------------
;  1.5 +  3.5 =  5.0
;  1.5 -  3.5 = -2.0
;  1.5 *  3.5 =  5.3
;  1.5 /  3.5 =  0.4
;  2.0 *  1.5 =  3.0