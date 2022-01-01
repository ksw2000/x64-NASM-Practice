;--------------------------------------------------------
; Read file without using feof()
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
        extern  fopen
        extern  fgetc
        extern  fclose

        section .data
path:   db      './demo.txt', 0
mode:   db      'r', 0
fmt:    db      '%c', 0
err:    db      'can not open demo.txt', 0xd, 0xa, 0

        section .bss
f:      resq    1  ; qword [f] = FILE*
char:   resq    1 ; record fgetc's c
        section .text
main:
        ; fopen(path, mode)
        mov     rcx, path
        mov     rdx, mode
        sub     rsp, 32
        call    fopen
        add     rsp, 32
        ; return rax (type: FILE*)
        
        ; check fopen is success (non-nil)
        cmp     rax, 0
        je      main.fopenNil

        mov     qword [f], rax

.read:
        ; read by fgetc()
        mov     rcx, [f]
        sub     rsp, 32
        call    fgetc
        add     rsp, 32

        cmp     eax, -1         ; if eax == EOF goto close
        jz      main.close

        ; print character
        mov     rcx, fmt
        mov     rdx, rax
        sub     rsp, 32
        call    printf
        add     rsp, 32
        jmp     main.read

.close:
        mov     rcx, [f]
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
