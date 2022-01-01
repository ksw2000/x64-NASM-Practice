;--------------------------------------------------------
; This is a practice of using xlatab instruction
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
table:  db      '0123456789abcdef', 0
msg:    db      'type a number 0-15: ', 0
err:    db      'error', 0
input:  db      '%d', 0
msgans: db      '%c', 0

        section .bss
num:    resb    1

        section .text
main:
        ; printf(message)
        mov     rcx, msg
        sub     rsp, 32
        call    printf
        add     rsp, 32

        ; scanf(input, &num)
        mov     rcx, input
        mov     rdx, num
        sub     rsp, 32
        call    scanf
        add     rsp, 32

        cmp     qword [num], 15
        ja      error               ; if num > 15
        cmp     qword [num], 0
        jb      error               ; if num < 0

        mov     rbx, table          ; rbx: base address
        mov     al, byte [num]      ; al: offset
        xlatb                       ; table look-up translation

        ; Locates a byte entry in a table in memory, using the contents of 
        ; the AL register as a table index, then copies the contents of the
        ; table entry back into the AL register. The index in the AL register
        ; is treated as an unsigned integer.
        
        ; The XLAT and XLATB instructions get the base address of the table
        ; in memory from either the DS:EBX or the DS:BX registers
        
        ; al is now the value of table[num] (char)

        ; printf(msgans, table[num])
        mov     rcx, msgans
        movzx   rdx, al
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret

error:
        mov     rcx, err
        sub     rsp, 32
        call    printf
        add     rsp, 32
        ret

; ---------------------- Output ----------------------
; type a number 0-15: 10
; a

; type a number 0-15: 16
; error