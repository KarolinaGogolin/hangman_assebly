; This is a pretty simple implementation of the function
; Below you'll find the list of known problems

; ---------- PROBLEMS WITH FUNCTION ----------
; doesn't properly check the user choice:
    ; when user inputs anything other than 'y' it still contiues the game
        ; exceptions: 
            ; when user inputs 'n' it leaves the game
            ; when user inputs 'n...' it leaves the game while writing other characters to the console (need to clear the buffer)
    ; the 'guesses_left' are not cleared when the game restarts

; returns rax = 1 if user wants to restart, 0 if not

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

restart_or_exit:
    lea rsi, [restart_msg]
    mov rdx, restart_msg_len
    call print_instruction

    ; read user choice
    mov rax, 0
    mov rdi, 0
    lea rsi, [user_choice]
    mov rdx, 1
    syscall

    ; check user choice
    cmp byte [user_choice], yes
    je .return_restart
    cmp byte [user_choice], no
    je .return_exit

    lea rsi, [invalid_choice_msg]
    mov rdx, invalid_choice_len
    call print_instruction

.return_restart
    mov rax, 1
    ret

.return_exit
    mov rax, 0
    ret
