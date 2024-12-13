; i've added this function to seperate the guessed arr from incorrect arr
; updates incorrect guess arr with guessesd char if it's not in secret
; decrements remaining attempts

section .text
global update_incorrect_guesses

update_incorrect_guesses:
    ; rdi: address of incorrect guesses array
    ; rsi: guessed character
    ; rdx: address of remaining attempts
    
    mov al, byte [rdi] ; check first char in array
.loop:
    cmp al, 0 ; uf null terminator, found empty slot
    je .add_guess

    inc rdi ; move to next character
    mov al, byte [rdi]; moad next character
    jmp .loop
.add_guess:
    mov byte [rdi], sil ; add guessed char to array
    dec dword [rdx] ; decrement remaining attempts
    ret
