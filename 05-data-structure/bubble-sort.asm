EXTERN printf
SECTION .data
    arr     dd  18, 13, 25, 44, 56, 78, 66, 99
    len     dq  8
    fmt     db  '%d ', 0
SECTION .bss
i    resq   1
j    resq   1

SECTION .text
start:
    ; for(i=0; i<len-1; i++)
    ;    for(j=i; j<len-1-i; j++)
    ;       if(arr[j]>arr[j+1])
    ;           swap(arr[j], arr[j+1])
    ;
    ; i = 0
    ; L1:
    ; j = i
    ; L2:
    ; if(arr[j] > arr[j+1])
    ;   swap
    ; j++
    ; if(j<len-1-i) goto L2
    ; i++
    ; if(i<len-1) goto L1

    mov     qword [i], 0
L1:
    mov     r12, qword [i]
    mov     qword [j], r12
L2:
    sal     r12, 2
    add     r12, arr
    mov     r14d, dword[r12]
    mov     r13, r12
    add     r13, 4
    mov     r15d, dword[r13]
    cmp     r14d, r15d
    jng     endif_1
    mov     dword[r12], r15d
    mov     dword[r13], r14d
endif_1:
    inc     qword[j]
    mov     r12, qword[j]
    mov     r13, qword[len]
    dec     r13
    sub     r13, qword[i]
    cmp     r12, r13
    jnl     endif_2
    jmp     L2
endif_2:
    inc     qword[i]
    mov     r12, qword[i]
    mov     r13, qword[len]
    dec     r13
    cmp     r12, r13
    jnl     L1

    mov     rcx, qword[len]
    mov     rbx, arr
printarray:
    push    rcx
    mov     rcx, fmt
    movsx   rdx, dword[rbx]
    sub     rsp, 32
    call    printf
    add     rsp, 32
    pop     rcx
    add     rbx, 4
    loop    printarray

    ret
