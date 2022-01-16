;--------------------------------------------------------------------
; Example of using `FCOMI` insturction
; It compares floating point values and set EFLAGS
;
; The FLAGS register is the status register that contains the current 
; state of a CPU. In i386 architecture the register is 16 bits wide. 
; Its successors, the EFLAGS and RFLAGS registers, are 32 bits and 64 
; bits wide, respectively. The wider registers retain compatibility 
; with their smaller predecessors.
;
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcrt.dll
;--------------------------------------------------------------------
        global  main
        extern  scanf
        extern  printf

        section .data
hint:   db      'please input two floating points respectly: ', 0
scanner:
        db      '%lf %lf', 0
compare:
        db      '%lf %c %lf', 0xa, 0xd, 0
gt:     db      '>'
lt:     db      '<'
eq:     db      '='
        section .bss
f1:     resq    1
f2:     resq    1
        section .text
main:
        ; printf(hint)
        mov     rcx, hint
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; scnaf(scanner, &f1, &f2)
        mov     rcx, scanner
        mov     rdx, f1
        mov     r8, f2
        sub     rsp, 32
        call    scanf
        add     rsp, 32

        finit
        fld     qword [f2]
        fld     qword [f1]
        fcomi   st0, st1                ; compare st0 to st1 and set eflags

        je      .equal                  ; if f1 = f2
        ja      .above                  ; else if f1 > f2
                                        ; else
        xor     r8, r8
        mov     r8b, byte [lt]
        jmp     .result
.above:
        xor     r8, r8
        mov     r8b, byte [gt]
        jmp     .result
.equal:
        xor     r8, r8
        mov     r8b, byte [eq]
        jmp     .result
.result:
        ; printf(compare, f1, r8 , f2) where r8 is '>', '=' or '<'
        mov     rcx, compare
        mov     rdx, qword [f1]
        mov     r9, qword [f2]
        sub     rsp, 32
        call    printf
        add     rsp, 32
        jmp     $$
        ret

; ---------------------- Output ----------------------
; please input two floating points respectly: 2.1 3.6
; 2.100000 < 3.600000

; please input two floating points respectly: 3.2 3.2
; 3.200000 = 3.200000

; please input two floating points respectly: 5.4 1.5
; 5.400000 > 1.500000