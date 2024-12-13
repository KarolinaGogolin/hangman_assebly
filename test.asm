section .data
    FALSE equ 0
    TRUE equ 1

section .text
global process_guess

process_guess:
    ; rdi: address of secret word
    ; rsi: address of guessed word array
    ; rdx: guessed char
    ; rcx: address to update match status (1 if match, 0 if no match)
    
    ; mov r8b, 0; initialize match flag to 0
    ; mov r8b,TRUE

.loop:
    mov al, byte [rdi]; load current char of the secret word
    cmp al, 10; check for null terminator
    je .end

    cmp al, dl; compare guessed char with current letter
    jne .next

    mov byte [rsi], al; update guessed word with matching letter
    mov r8b, 1; set match flag to 1
.next:
    ; move to nex char (secret then guesses)
    inc rdi
    inc rsi
    jmp .loop

.end:
    ; mov byte [rcx], r8b; store match flag
    ret

