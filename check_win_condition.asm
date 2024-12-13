; check is guessed word matches with secret

section .text
global check_win_condition

check_win_condition:
    ; rdi: address of secret word
    ; rsi: address of guessed word array
    ; rdx: address to store win flag (1 if win, 0 otherwise)

    mov r8b, 1 ; assume win initially

.loop:
    ; load chars (secret then guessed)
    mov al, byte [rdi]
    mov bl, byte [rsi]
    cmp al, 0 ; check for null terminator in secret
    je .end

    cmp al, bl ; compare secret and guessed chars
    jne .not_win

    inc rdi ; move in secret
    inc rsi ; move in guessed
    jmp .loop

.not_win:
    mov r8b, 0 ; set win flag to 0

.end:
    mov byte [rdx], r8b; store win flag
    ret
