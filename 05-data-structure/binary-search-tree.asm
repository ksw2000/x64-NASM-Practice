EXTERN printf, scanf
SECTION .data
    msg     db 'please input number, 0 to end: ', 0
    infmt   db '%I64d', 0
    outfmt  db 'data: %I64d now: %p left: %p right: %p', 0dh, 0ah, 0

SECTION .bss
num     resq    1
left    resq    128
right   resq    128
data    resq    128
root    resq    1

SECTION .text
start:
    mov     rsi, 0
    mov     qword [root], rsi

input:
    mov     rcx, msg
    sub     rsp, 32
    call    printf
    add     rsp, 32

    mov     rcx, infmt
    mov     rdx, num
    sub     rsp, 32
    call    scanf
    add     rsp, 32

    ; rbp   previous
    ; rbx   now

    mov     r15, qword [num]
    cmp     r15, 0
    je      print_table

    add     rsi, 8
    mov     qword [data+rsi], r15
    mov     qword [left+rsi], 0
    mov     qword [right+rsi], 0
    mov     rbx, 0                  ; previous
    mov     rbp, [root]             ; current traversal

find_position:
    cmp     rbp, 0
    je      insert

    mov     rbx, rbp
    cmp     qword [data+rbp], r15
    jg      goleft
    mov     rbp, qword [right+rbp]
    jmp     find_position
goleft:
    mov     rbp, qword [left+rbp]
    jmp     find_position

insert:
    ; if rbp is null -> first create
    cmp     rbx, 0
    je      first_insert
    ; else
    ; if previous is greater
    cmp     qword [data+rbx], r15
    jg      insert_left
    ; else insert_right
    mov     qword [right+rbx], rsi
    jmp     input
insert_left:
    mov     qword [left+rbx], rsi
    jmp     input

first_insert:
    mov     qword [root], rsi
    jmp     input

print_table:
    mov     r12, rsi        ; set the stop condition
    mov     rsi, [root]     ; init

repeat_print_table:
    mov     rcx, outfmt
    mov     rdx, [data+rsi]
    mov     r8, rsi
    add     r8, data
    mov     r9, [left+rsi]
    add     r9, data
    mov     r13, [right+rsi]
    add     r13, data
    push    r13
    sub     rsp, 32
    call    printf
    add     rsp, 40
    add     rsi, 8
    cmp     rsi, r12
    jng      repeat_print_table

    ret
