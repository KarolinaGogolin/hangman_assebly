; This function takes a string that the user input and turns the uppercase letters into lowercase
; arguments: rdi -> the addres to users input
; returns: rax -> the altered secret_word


section .text
    global to_lower_case_function

to_lower_case_function:
    mov rsi, rdi       ; putting the users input into rsi

    CheckLoop: 

        mov al, byte[rsi] ; putting current char into dl

        cmp al, 0
        jle Exit

        cmp al, 10
        je Exit

        cmp al, 'a'   
        jl ToLowerCase  ; if the character is smaller than 'a' that means it's uppercase because this function is called after validating the input

        jmp NextChar ; jumping to increment the current char

    ToLowerCase:
        add al, 32
        mov byte [rsi], al  ; updating the rsi with lowercase letter
        jmp NextChar
    NextChar:  
        inc rsi
        jmp CheckLoop
    Exit:
ret