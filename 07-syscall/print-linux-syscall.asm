;----------------------------------------
; Assemble:
; nasm -f elf64 {filename}.asm
; Link:
; gcc {filename}.obj -o {filename}.exe
; syscall table for x86_64
; https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
;----------------------------------------

SECTION .data
helloMsg:       db 0xd, "Hello World", 0xd, 0xa
helloMsgLen:    equ $-helloMsg

    global main
SECTION .text
main:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; the file descriptor of stdout
                            ; stdout: 1, stdin: 0, stderr: 2
    mov rsi, helloMsg       ; const char* buf
    mov rdx, helloMsgLen    ; size_t
    syscall

    mov rax, 60             ; sys_exit
    mov rdi, 0              ; int error_code
    syscall
