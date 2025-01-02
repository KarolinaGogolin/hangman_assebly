; i've added this function to seperate the guessed arr from incorrect arr
; updates incorrect guess arr with guessesd char if it's not in secret
; decrements remaining attempts
section .data
    already_guessed_mes db "This letter was already guessed!",10,0
    already_guessed_mes_l equ $-already_guessed_mes

section .text
global update_incorrect_guesses
extern print_instruction

update_incorrect_guesses:
    ; rdi: address of incorrect guesses array
    ; rsi: guessed character
    ; rdx: address of remaining attempts
    push rdi ; saving the original start address of the array
    add rdi,19 ; skipping the "Incorrect guesses: "
    
.loop:
    cmp byte[rdi],0 ; uf null terminator, found empty slot
    je .add_guess

    cmp byte[rdi], sil
    je .already_guessed

    inc rdi ; move to next character
    jmp .loop
.already_guessed:
    pop rdi
    lea rsi, [already_guessed_mes]
    mov rdx, already_guessed_mes_l                
    call print_instruction 
    ret
.add_guess:
    mov byte[rdi],sil
    dec dword [rdx] ; decrement remaining attempts
    pop rdi
    ret
