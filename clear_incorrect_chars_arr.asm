
section .text
global clear_incorrect_chars_arr


clear_incorrect_chars_arr:
    ; rdi: address of incorrect guesses array
    ; rsi: guessed character
    ; rdx: address of remaining attempts
    push rdi ; saving the original start address of the array
    add rdi,19 ; skipping the "Incorrect guesses: "
    ; mov al, byte [rdi] ; check first char in array
.loop:
    ; cmp al, 0 ; uf null terminator, found empty slot
    cmp byte[rdi],0
    je .exit

    cmp byte[rdi],10
    je .exit

    mov byte[rdi],0
    inc rdi ; move to next character
    ; mov al, byte [rdi]; moad next character
    jmp .loop
.exit:
    pop rdi
    ret
