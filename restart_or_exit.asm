; Function that asks the user if they want to play again and processes their choice

; returns rax = 7 if user wants to restart, 0 if not
; why not 1 but 7 you might ask? Thats because this is the original number of attempts left and can be used to restore them in main

section .data
    ; restart msg
    restart_msg db "Do you want to restart the game? (y/n)",10,13,0
    restart_msg_len equ $-restart_msg

    ; invalid choice msg
    invalid_choice_msg db "Invalid choice. Please enter 'y' or 'n'",10,13,0
    invalid_choice_len equ $-invalid_choice_msg

    ; options
    yes equ 'y'
    no equ 'n'

section .bss
    user_choice resb 1

section .text
    global restart_or_exit
    extern print_instruction
    extern read_guess

restart_or_exit:

    lea rsi, [restart_msg]
    mov rdx, restart_msg_len
    call print_instruction

    call read_guess

    ; check user choice
    cmp byte [rax], yes
    je .return_restart
    cmp byte [rax], no
    je .return_exit

    lea rsi, [invalid_choice_msg]
    mov rdx, invalid_choice_len
    call print_instruction
    jmp restart_or_exit

.return_restart
    mov rax, 7
    ret

.return_exit
    mov rax, 0
    ret
