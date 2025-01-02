; funcion used for printing to decrease the amount of code
; rsi -> the thing to print
; rdx -> the length to of the thing to print
section .text
    global print_instruction

print_instruction:
    mov rax, 1      ; sys_write system call
    mov rdi, 1      ; file descriptor 1 -> stdout
    syscall
ret

    