EXTERN printf, scanf
SECTION .data
    head    dq  0
    tail    dq  0
    msg     db  'keyin a number (>0), 0 end: ', 0
    infmt   db  '%I64d', 0
    outfmt  db  '[%I64d] -> ',0
    nullmsg db  'NULL', 0

SECTION .bss
data    resq    100
link    resq    100
num     resq    1

SECTION .text
start:
    mov     rsi, 0
    mov     qword [head], rsi
    mov     qword [tail], rsi
    mov     qword [data], -1
    mov     qword [link], rsi
    ; The first node's data is -1

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

    cmp     qword [num], 0      ; is end?
    je      print_list

    add     rsi, 8              ; create new node
    mov     rax, qword [num]
    mov     qword [data+rsi], rax
    mov     rbp, qword [head]
    mov     rbx, rbp            ; now, rbx = [head]

process:
    mov     rax, [data+rbp]
    cmp     qword [num], rax        ; is num less than rax?
    jl      insert                  ; yes
    ; find the next node we can insert new node after it.
    mov     rbx, rbp                ; no (let rbx be previous node)
    mov     rbp, qword [link+rbx]   ;    (let rbp be next node)
    cmp     rbp, 0                  ; is list end?
    je      insert                 ; insert!
    jmp     process

insert:     ; [data+rbx] -> [num] -> [data+rbp]
    mov     qword [link+rsi], rbp   ; (let rbp be next node)
    mov     qword [link+rbx], rsi   ; (let rbx be previous node)
    jmp     input

insert2:
    mov     qword [link+rsi], 0     ; the next of node [rsi] is null
    mov     rdi, qword[tail]
    mov     qword[link+rdi], rsi    ; make the previous node connect to [rsi]
    mov     qword[tail], rsi        ; update [tail]
    jmp     input

print_list:
    mov     rbx, qword [head]
    mov     rbp, qword [link+rbx]

repeat_printf_list:
    mov     rcx, outfmt
    mov     rdx, [data+rbp]
    sub     rsp, 32
    call    printf
    add     rsp, 32

    mov     rbp, [link+rbp]
    cmp     rbp, 0
    jnz     repeat_printf_list      ; if the next node is not null

    mov     rcx, nullmsg
    sub     rsp, 32
    call    printf
    add     rsp, 32

    ret
