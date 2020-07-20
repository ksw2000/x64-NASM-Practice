; use inorder traversal
EXTERN printf, scanf
SECTION .data
    msg     db 'please input number, 0 to end: ', 0
    infmt   db '%I64d', 0
    outfmt  db 'data: %I64d now: %p left: %p right: %p', 0dh, 0ah, 0
    inorderFmt      db  '[%I64d] ', 0
SECTION .bss
num     resq    1
left    resq    128
right   resq    128
data    resq    128
root    resq    1

SECTION .text
;   inorder in C
;   inorder(node){
;       if(node!=null){
;           inorder(node->left);
;           printf(node->data);
;           inorder(node->right);
;       }
;   }
;

inorder:    ;rcx = node
    cmp     rcx, 0
    je      .end
    mov     qword [rsp + 8], rcx

    mov     rcx, qword [rsp + 8]
    add     rcx, left
    mov     rcx, qword [rcx]
    sub     rsp, 8
    call    inorder
    add     rsp, 8

    ;print
    mov     rdx, qword [rsp + 8]
    add     rdx, data
    mov     rdx, qword [rdx]
    mov     rcx, inorderFmt
    sub     rsp, 32
    call    printf
    add     rsp, 32

    mov     rcx, qword [rsp + 8]
    add     rcx, right
    mov     rcx, qword [rcx]
    sub     rsp, 8
    call    inorder
    add     rsp, 8
.end:
    ret

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
    je      print_result

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

    mov     rsp, 32

print_result:
    mov     rcx, [root]
    call    inorder
