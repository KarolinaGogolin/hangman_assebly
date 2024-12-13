; checks if the player has lost

section .text
global check_lose_condition

check_lose_condition:
    ; rdi: address of remaining attempts
    ; rsi: address to store lose flag (1 if lose, 0 otherwise)

    mov eax, dword [rdi] ; load remaining attempts
    test eax, eax ; check if remaining attempts is zero
    setz byte [rsi] ; set the lose flag (1 if zero, 0 otherwise)
    ret
