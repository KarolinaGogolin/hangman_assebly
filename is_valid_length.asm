; This function takes a string that the user input and counts the length
; arguments: rdi -> the addres to users input
; returns: rax -> the length of the string

section .text 
    global is_valid_length

is_valid_length:
; Initialisation
;-------------------------------------------------------
    mov rsi, rdi        ; putting the users input into rsi
    xor rax,rax         ; clearing rax

; Looping through the whole input to get the length
;-------------------------------------------------------
    CheckLoop: ;apparently cannot use al because it is lower part of rax and overwriting my return value so im using dl instead

        mov dl, byte[rsi] ;putting current char into dl

        cmp dl, 0     ; checking for null at the end
        jle Exit      ; if current char is null then exit

        cmp dl, 10    ; checking for lf character (the end of the line char)
        je Exit       ; if true then exit

        jmp NextChar ; jumping to increment the current char

    NextChar:  
        inc rsi
        inc rax
        jmp CheckLoop
    Exit:
ret