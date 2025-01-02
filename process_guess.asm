; Function that checks if guessed char matches any char in secret word
; updates the guessed word with the matched char
section .data
    already_guessed_mes db "This letter was already guessed!",10,0
    already_guessed_mes_l equ $-already_guessed_mes

section .text
global process_guess
extern print_instruction
process_guess:
    ; rdi: address of secret word
    ; rsi: address of guessed word array
    ; rdx: guessed char
    ; rcx: guesses left
    ; rax: address to update match status (1 if match, 0 if no match)
    
    mov r8, 0; initialize match flag to 0

.loop:
    mov al, byte [rdi]; load current char of the secret word
    cmp al, 10; check for endl terminator
    je .end

    cmp al, 0; check for null terminator
    je .end

    cmp al, byte[rdx]; compare guessed char with current letter
    jne .next

    cmp byte[rsi], al
    je .was_guessed

    mov byte [rsi], al; update guessed word with matching letter
    mov r8, 1 ; set match flag to 1
.next:
    ; move to nex char (secret then guesses)
    inc rdi
    inc rsi
    jmp .loop
.was_guessed:
    mov r8, 1
    lea rsi, [already_guessed_mes]
    mov rdx, already_guessed_mes_l                
    call print_instruction
.end:
    xor rax,rax
    mov rax, r8
    ret
