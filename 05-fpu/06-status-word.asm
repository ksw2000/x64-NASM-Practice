;--------------------------------------------------------
; An example of fetching status word in FPU.
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
        extern  scanf

        section .data
msg:    db      'please input two floating numbers: ', 0
inFmt:  db      '%lf %lf', 0
outFmt: db      'flag reg = %02I64xH', 0xd, 0xa, 0
result: db      '%lf %s %lf', 0xd, 0xa,0
gt:     db      '>', 0
lt:     db      '<', 0
eq:     db      '=', 0
newline:
        db      0xa, 0xd, 0
        section .bss
a:      resq    1
b:      resq    1
flag:   resq    1
op:     resq    1
        section .text
main:
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

        ; printf(msg)
        mov     rcx, msg
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; scanf(inFmt, &a, &b)
        mov     rcx, inFmt
        mov     rdx, a
        mov     r8, b
        sub     rsp, 32
        call    scanf
        add     rsp, 32

        finit
        fld     qword [a]
        fcom    qword [b]       ; a compares to b
        fstsw   ax              ; store FPU flags to AH
        sahf                    ; store AH into (CPU's) Flags

        pushfq                  ; Push EFLAGS Register onto the Stack
        pop     qword [flag]

        ; print(flag)
        mov     rcx, outFmt
        mov     rdx, qword [flag]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; flag & 0000 0001
        test    byte [flag], 00000001B          ; test C0 (C0 is carry flag)
        jnz     .less                           ; if C0 = 1 goto less
        ; flag & 0100 0000
        test    byte [flag], 01000000B          ; test C3 (C3 is zero flag)
        jnz     .equal                          ; if C3 = 1 goto equal
        mov     qword[op], gt
        jmp     .comp_result
.less:
        mov     qword[op], lt
        jmp     .comp_result
.equal:
        mov     qword[op], eq
.comp_result:
        ; printf(result, a, op, b)
        mov     rcx, result
        mov     rdx, qword [a]
        mov     r8, qword [op]
        mov     r9, qword [b]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; printf("\r\n")
        mov     rcx, newline
        sub     rsp, 32
        call    printf
        add     rsp, 32
        jmp     $$
        ret

; ---------------------- Output ----------------------
; please input two floating numbers: 1.2 6.5
; flag reg = 213H
; 1.200000 < 6.500000

; please input two floating numbers: 8.1 1.2
; flag reg = 212H
; 8.100000 > 1.200000

; please input two floating numbers: 3 3
; flag reg = 252H
; 3.000000 = 3.000000