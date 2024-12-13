section .rodata
    welcome_msg db "Welcome to HANGMAN!" ,10,13, "Please enter an english word with length between 5 and 20 letters. For any word that is entered and is longer than 20 letters only the first 20 letters will be saved.",10,13,0, ;10,13 -> \n 0 -> \0
    welcome_msg_l equ $-welcome_msg
    valid_input_msg db "The secret word you entered is saved! Let the fun begin!",10,13,0
    valid_input_msg_l equ $-valid_input_msg
    invalid_input_msg db "The secret word you entered contains ILLEGAL(!) characters. Please make sure it only contains english alphabet letters (a to z)",10,13,"Try again: ",0
    invalid_input_msg_l equ $-invalid_input_msg
    invalid_length_msg db "The secret word you entered is too short. Please make sure it has at least 5 letters",10,13,"Try again: ",0
    invalid_length_msg_l equ $-invalid_length_msg

section .bss
    secret_word resb 20
section .text
    global read_secret_function
    extern print_instruction
    extern is_valid_input
    extern to_lower_case_function
    extern is_valid_length
    extern clear_buffer

read_secret_function:
    
    ;printing initial instructions:
    lea rsi, [welcome_msg]      ; address of the instruction to be displayed
    mov rdx, welcome_msg_l      ; length of the instruction to be displayed
    call print_instruction      ; using a function to set rax,rdi and syscall for printing to console for brevity

; Loop for user input
;-------------------------------------------------------
    InvalidInput:   
   
    mov rsi,20
    lea rdi, [secret_word]          ; clearing the buffer(secret_word + stdin)
    call clear_buffer
                                    ; taking the input from the user -> could be put into separate functions but wanted to keep it here since its the main point of this function
    mov rax, 0                      ; sys_read system call
    mov rdi, 0                      ; file descriptor 0 -> stdin
    lea rsi, [secret_word]          ; load the address of the destination
    mov rdx, 20                     ; max number of bytes to read (if user writes more only the 20 will be checked and saved if valid)
    syscall

; Checking for the valid length
;-------------------------------------------------------
    lea rdi, [secret_word]          ; checking if the words length is at least 5
    call is_valid_length

    cmp rax, 4
    jg CheckIsValidInput            ; if valid length then proceed to check chars validity

    ; Invalid length
    ;---------------------------------------
    lea rsi, [invalid_length_msg]   ; displaying instruction informing of invalid input
    mov rdx, invalid_length_msg_l
    call print_instruction

    jmp InvalidInput                ; going back to input

; Checking for valid characters
;-------------------------------------------------------
    CheckIsValidInput:

    lea rdi, [secret_word]  
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
   
    lea rsi, [valid_input_msg]
    mov rdx, valid_input_msg_l 
    call print_instruction

    lea rdi, [secret_word]          ; changing the secret word to all lowercase
    call to_lower_case_function
    
    mov rsi,0
    lea rdi,[secret_word]            
    call clear_buffer   

    lea rax,[secret_word]           ; putting the finalised word for return
ret