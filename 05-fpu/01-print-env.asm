;--------------------------------------------------------
; A practice getting environments of FPU.
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
c:      dq      5.5
d:      dq      0.0

fmt0:   db      '%s %5.2lf', 0xd, 0xa, 0
fmt1:   db      '   %s %04I64xH', 0

msg0:   db      'after FINIT', 0xd, 0xa, 0
msg1:   db      'after pushing', 0
msg2:   db      'after poping', 0
msgc:   db      'control = ', 0
msgs:   db      'status = ', 0
msgt:   db      'tag = ', 0

newline: 
        db      0xd, 0xa, 0
        
        section .bss
env:    resb    28              ; need 28 bytes     

        section .text
main:
        finit                   ; Initialize Floating-Point Unit
        
        mov     rcx, msg0
        sub     rsp, 32
        call    printf
        add     rsp, 32

        call    getenv

        fld     qword [a]       ; load `a` (push `a` to stack)
                                ; we can only push the value in memory instead of in register

        ; printf(fmt0, msg1, a)
        mov     rcx, fmt0
        mov     rdx, msg1
        mov     r8, [a]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        call    getenv

        fld     qword [b]

        ; printf(fmt0, msg1, b)
        mov     rcx, fmt0
        mov     rdx, msg1
        mov     r8, [b]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        call    getenv

        fld     qword [c]       ; load [c]

        ; printf(fmt0, msg1, c)
        mov     rcx, fmt0
        mov     rdx, msg1
        mov     r8, [c]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        call    getenv

        fstp    qword [d]       ; store TOS and pop

        ; printf(fmt0, msg2, d)
        mov     rcx, fmt0
        mov     rdx, msg2
        mov     r8, [d]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        call    getenv

        fstp    qword [d]       ; store TOS and pop

        ; printf(fmt0, msg2, d)
        mov     rcx, fmt0
        mov     rdx, msg2
        mov     r8, [d]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        call    getenv

        fstp    qword [d]       ; store TOS and pop

        ; printf(fmt0, msg2, d)
        mov     rcx, fmt0
        mov     rdx, msg2
        mov     r8, [d]
        sub     rsp, 32
        call    printf
        add     rsp, 32

        call    getenv
        ret

getenv:
        ; FPU env 
        fstenv  [env]           
        ; https://i.imgur.com/lvY992h.png
        ; store environment to memory
        ; control word ( 16 bits)
        ; status word  ( 16 bits)
        ; tag word     ( 16 bits)
        ; other        (112 bits)

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
        mov     ax, word [env]

        mov     rcx, fmt1
        mov     rdx, msgc
        mov     r8, rax
        sub     rsp, 32
        call    printf                  ; print 4-digit hex
        add     rsp, 32

        xor     rax, rax
        mov     ax, word [env+4]
        mov     rcx, fmt1
        mov     rdx, msgs
        mov     r8, rax
        sub     rsp, 32
        call    printf                  ; print 4-digit hex
        add     rsp, 32

        xor     rax, rax
        mov     ax, word [env+8]
        mov     rcx, fmt1
        mov     rdx, msgt
        mov     r8, rax
        sub     rsp, 32
        call    printf                  ; print 4-digit hex
        add     rsp, 32

        mov     rcx, newline
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret

; ---------------------- Output ----------------------
; after FINIT
;    control =  037fH   status =  0000H   tag =  ffffH
; after pushing  1.50
;    control =  037fH   status =  3800H   tag =  3fffH
; after pushing  3.50
;    control =  037fH   status =  3000H   tag =  0fffH
; after pushing  5.50
;    control =  037fH   status =  2800H   tag =  03ffH
; after poping  5.50
;    control =  037fH   status =  3000H   tag =  0fffH
; after poping  3.50
;    control =  037fH   status =  3800H   tag =  3fffH
; after poping  1.50
;    control =  037fH   status =  0000H   tag =  ffffH