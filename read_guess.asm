; This function takes a string that the user input and counts the length
; returns: rax -> the valid letter
section .rodata
    enter_input_msg db "Please enter a character: ",0 ;10,13 -> \n 0 -> \0
    enter_input_msg_l equ $-enter_input_msg
    invalid_input_msg db "Invalid input! You can enter only letters.",10,13,"Try again: ",0
    invalid_input_msg_l equ $-invalid_input_msg
    invalid_length_msg db "Your guess is empty. Please make sure to guess a letter.",10,13,"Try again: ",0
    invalid_length_msg_l equ $-invalid_length_msg

section .bss
    guess_buff resb 1
    dummy resb 1

section .text 
    global read_guess
    extern is_valid_length
    extern is_valid_input
    extern to_lower_case_function
    extern clear_buffer
    extern print_instruction

read_guess:
    lea rsi, [enter_input_msg]     ; address of the instruction to be displayed
    mov rdx, enter_input_msg_l     ; length of the instruction to be displayed
    call print_instruction         ; using a function to set rax,rdi and syscall for printing to console for brevity

; Loop for user input
;-------------------------------------------------------
    InvalidInput:   
   
    mov rsi,1                       ; clearing the previous guess and stdin
    lea rdi, [guess_buff]      
    call clear_buffer
                                    ; taking the input from the user -> could be put into separate functions but wanted to keep it here since its the main point of this function
    mov rax, 0                      ; sys_read system call
    mov rdi, 0                      ; file descriptor 0 -> stdin
    lea rsi, [guess_buff]           ; load the address of the destination
    mov rdx, 1                      ; max number of bytes to read (if user writes more only the 20 will be checked and saved if valid)
    syscall

; Checking for the valid length
;-------------------------------------------------------
    lea rdi, [guess_buff]           ; checking the length of input
    call is_valid_length

    cmp rax, 1
    je CheckIsValidInput            ; if valid length then proceed to check chars validity

    ; Invalid length
    ;---------------------------------------
    lea rsi, [invalid_length_msg]   ; displaying instruction informing of invalid input
    mov rdx, invalid_length_msg_l
    call print_instruction

    jmp InvalidInput                ; going back to input

; Checking for valid characters
;-------------------------------------------------------
    CheckIsValidInput:

    lea rdi, [guess_buff]  
    call is_valid_input             ; checking if the input chars are valid

    cmp rax, 1
    je ValidInput                   ; if valid jump to processing the users input

    ; Invalid characters
    ;---------------------------------------
    lea rsi, [invalid_input_msg]    ; displaying instruction informing of invalid input
    mov rdx, invalid_input_msg_l
    call print_instruction

    jmp InvalidInput                ; going back to input

; Finalising the valid word
;-------------------------------------------------------
    ValidInput:

    lea rdi, [guess_buff]           ; changing to lowercase
    call to_lower_case_function

    mov rsi,0
    lea rdi,[guess_buff]           
    call clear_buffer               ; clearing possible leftovers from stdin

    ; mov al, byte [guess_buff]
    lea rax,[guess_buff]            ; putting the finalised word for return
ret