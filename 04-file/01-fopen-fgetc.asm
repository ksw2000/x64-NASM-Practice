;--------------------------------------------------------
; A practice using clib file processing function 
; such as fopen() fgetc() in NASM
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
        extern  fopen   ; FILE *fopen(const char *filename, const char *mode)
        extern  fgetc   ; int fgetc(FILE *stream) return unsigned character which is got from `stream`
        extern  feof    ; int feof(FILE *stream) return non-zero value if `stream` at the end of file
        extern  fclose

        section .data
path:   db      './demo.txt', 0         ; encode: utf8
mode:   db      'r', 0                  ; only read
fmt:    db      '%c', 0
err:    db      'can not open demo.txt', 0xd, 0xa, 0

        section .bss
f:      resq    1                       ; typeof qword[f] is FILE*
char:   resq    1                       ; record fgetc's c

        section .text
main:
        ; fopen(path, mode)
        mov     rcx, path
        mov     rdx, mode
        sub     rsp, 32
        call    fopen
        add     rsp, 32
        ; FILE* is at rax
        
        mov     qword [f], rax
        cmp     rax, 0
        je      fopenNil

.read:
        ; read by fgetc()
        ; Note: use [f] not f !!
        ; Note: use [f] not f !!
        ; Note: use [f] not f !!
        
        ; f   -> FILE**
        ; [f] -> FILE*

        mov     rcx, [f]
        sub     rsp, 32
        call    fgetc
        add     rsp, 32
        mov     qword [char], rax

        ; use feof to check wheather here is eof
        mov     rcx, [f]
        sub     rsp, 32
        call    feof
        add     rsp, 32
        cmp     rax, 0
        jne     .close

        ; printf(fmt, char)
        mov     rcx, fmt
        mov     rdx, qword [char]
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

fopenNil:
        mov     rcx, err
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret

; ---------------------- Output ----------------------
; 星の力を秘めし鍵よ
; 真の姿を我の前に示せ
; 契約のもと
; さくらが命じる
; レリーズ