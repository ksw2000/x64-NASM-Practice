;--------------------------------------------------------
; This is a practice of spliting a string
; 1. load string byte
; 2. store string byte
;
; We want to split float number
; e.g. 3.14 -> 3 & 14
; 
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcrt.dll
;--------------------------------------------------------

        global  main
        extern  scanf
        extern  printf
        extern  strlen

        section .data
hint:   db      'please input an float number: ', 0
input:  db      '%s', 0
msgErr: db      'there is an invalid character', 0
result: db      '%s & %s', 0

        section .bss
numStr: resb    512
left:   resb    256
right:  resb    256

        section .text
main:
        ; print hint
        mov     rcx, hint
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; scan
        mov     rcx, input
        mov     rdx, numStr
        sub     rsp, 32
        call    scanf
        add     rsp, 32

        ; get string len
        mov     rcx, numStr
        sub     rsp, 32
        call    strlen
        add     rsp, 32

        ; init for left
        mov     rcx, rax        ; the length of string is in rax
        mov     rsi, numStr     ; source string
        mov     rdi, left       ; destination string
        cld                     ; direction from left to right

.L1:
        lodsb                   ; load string byte at address `rsi` into `al`
                                ; loadsw: load string word at address `rsi` into `ax`
                                ; loadsd: load string double word at address `rsi` into `eax`
                                ; loadsq: load string quad word at address `rsi` into `rax` 
                                
        cmp     al, '.'
        je      main.L2         ; change rdi from left to right
        cmp     al, 0           ; if character is equal to EOL
        je      .L3
        cmp     al, '0'         ; if character is below 0
        jb      err
        cmp     al, '9'         ; if character is above 9
        ja      err
        stosb                   ; stroe string byte at address `rdi` into `al`
        loop    main.L1

.L2:
        mov     rdi, right
        jmp     main.L1

.L3:
        mov     rcx, result
        mov     rdx, left
        mov     r8, right
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret

err:
        mov     rcx, msgErr
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret
