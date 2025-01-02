; function that clears the array of the incorrectly guessed characters in case the user would like to restart the game
section .text
global clear_incorrect_chars_arr


clear_incorrect_chars_arr:
    ; rdi: address of incorrect guesses array
    ; rsi: guessed character
    ; rdx: address of remaining attempts

    push rdi ; saving the original start address of the array
    add rdi,19 ; skipping the "Incorrect guesses: "

.loop:
    
    cmp byte[rdi],0 ; if there is a null found the first empty slot
    je .exit

    cmp byte[rdi],10 ; if there is a newline found the end of the array
    je .exit

    mov byte[rdi],0
    inc rdi ; move to next character

    jmp .loop
.exit:
    pop rdi
    ret
