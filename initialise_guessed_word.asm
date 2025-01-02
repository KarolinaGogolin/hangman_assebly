; This function takes a string that the user input initialises the guessed word with however many '_' as there is letters in the word
; arguments: rdi -> the addres to users input
; returns: rax -> the length of the string
section .text 
    global initialise_guessed_word

initialise_guessed_word:
; Initialisation
;-------------------------------------------------------
    xor rdx, rdx

; Looping through the whole input to get the length
;-------------------------------------------------------
    CheckLoop:
    
        mov al, byte[rdi+rdx] ;putting current char into al

        cmp al, 0     ; checking for null at the end
        jle Exit      ; if current char is null then exit

        cmp al, 10    ; checking for lf character (the end of the line char)
        je Exit       ; if true then exit

        mov byte[rsi+rdx], '_'

        inc rdx
        jmp CheckLoop
    Exit:
ret