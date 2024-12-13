; This function takes a string that the user input and checks whether the characters in it are either lowercase or uppercase letters.
; In case at least one of the characters is not a letter the function returns false
; arguments: rdi -> the addres to users input
; returns: rax -> 0 if FALSE, 1 if TRUE


section .data
    FALSE equ 0
    TRUE equ 1

section .text
    global is_valid_input

is_valid_input:
; Initialisation
;-------------------------------------------------------
    mov rsi, rdi       ;putting the users input into rsi
    mov rax,TRUE       ;defaulting true

; Looping through the input
;-------------------------------------------------------
    CheckLoop: ;apparently cannot use al because it is lower part of rax and overwriting my return value so im using dl instead

        mov dl, byte[rsi] ;putting current char into dl

        cmp dl, 0     ; checking for null at the end
        jle Exit      ; if current char is null then exit

        cmp dl, 10    ; checking for lf character (the end of the line char)
        je Exit       ; if true then exit

        cmp dl, 'A'   
        jl ExitFalse  ; if the character is smaller than 'A' then input is invalid

        cmp dl, 'z'     
        jg ExitFalse  ; if the character is bigger than 'z' then input is invalid

        cmp dl, 'Z'
        jg CheckASCIIBetween91And96 ; if the current char is bigger then 'Z' jumping to check if it is inbetween lower and uppercase letters on ASCII table

        jmp NextChar ; jumping to increment the current char
    ExitFalse:
        mov rax, FALSE
        ret
    NextChar:  
        inc rsi
        jmp CheckLoop
    CheckASCIIBetween91And96:
        cmp dl, 'a'
        jl ExitFalse    ; if the current char is smaller than 'a' its invalid input
        jmp NextChar
    Exit:
ret