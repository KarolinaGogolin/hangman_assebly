; checks if guessed char matches any char in secret word
; updates the guessed word with the matched char
section .text
global process_guess

process_guess:
    ; rdi: address of secret word
    ; rsi: address of guessed word array
    ; rdx: guessed char
    ; rcx: guesses left
    ; rcx: address to update match status (1 if match, 0 if no match)
    
    ; mov bl, 0
    mov r8, 0; initialize match flag to 0

.loop:
    mov al, byte [rdi]; load current char of the secret word
    cmp al, 10; check for endl terminator
    je .end

      cmp al, 0; check for null terminator
    je .end

    cmp al, byte[rdx]; compare guessed char with current letter
    jne .next

    mov byte [rsi], al; update guessed word with matching letter
    ; mov dl, 1; set match flag to 1
    mov r8, 1
.next:
    ; move to nex char (secret then guesses)
    inc rdi
    inc rsi
    jmp .loop

.end:
    ; xor rax,rax
    cmp r8,1
    je .therealend
    dec rcx
.therealend:
    ret
