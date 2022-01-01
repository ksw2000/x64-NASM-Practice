;--------------------------------------------------------
; practice using fputs() and gets()
;
; Assemble:
; nasm -f win64 {filename}.asm
;
; Link:
; gcc {filename}.obj -o {filename}.exe
; goLink /console {filename}.obj /entry main msvcrt.dll
;
; Run: (command line)
; chcp 65001
; {filename}.exe
;--------------------------------------------------------

        global  main
        extern  printf
        extern  strlen
        extern  fopen
        extern  gets
        extern  fputs
        extern  fclose

        section .data
msg:    db 'input some text: ', 0
path:   db './_demo_write.txt', 0       ; gitignore _*
mode:   db 'w',0
fmt:    db 'success', 0xd, 0xa, 0
err:    db 'fopen error', 0

        section .bss
buf:    resb 256
fp:     resw 1

        section .text
main:
        ; fp = fopen(path, "w")
        mov     rcx, path
        mov     rdx, mode
        sub     rsp, 32
        call    fopen
        add     rsp, 32
        mov     qword [fp], rax
        cmp     rax, 0
        je      main.fopenNil

.write:
        ; print hint
        mov     rcx, msg
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; gets(buf)
        mov     rcx, buf
        sub     rsp, 32
        call    gets
        add     rsp, 32
        cmp     rax, 0          ; if get EOL(ctrl+z)
        je      main.end        ; type ctrl+z is equal to EOF

        ; get length of string
        mov     rcx, buf
        sub     rsp, 32
        call    strlen
        add     rsp, 32         ; rax = string len
        
        ; insert 0xa, 0x0 at the end of buf
        mov     rbx, buf
        add     rbx, rax
        mov     byte [rbx], 0xa
        mov     byte [rbx + 1], 0x0

        ; fputs
        mov     rcx, buf
        mov     rdx, [fp]
        sub     rsp, 32
        call    fputs
        add     rsp, 32

        ; print success
        mov     rcx, fmt
        sub     rsp, 32
        call    printf
        add     rsp, 32
        jmp     main.write

.end:
        mov     rcx, [fp]
        sub     rsp, 32
        call    fclose
        add     rsp, 32
        ret

.fopenNil:
        mov     rcx, err
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret
