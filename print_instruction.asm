section .text
    global print_instruction

print_instruction:
    mov rax, 1      ; sys_write system call
    mov rdi, 1      ; file descriptor 1 -> stdout
    syscall
ret

    