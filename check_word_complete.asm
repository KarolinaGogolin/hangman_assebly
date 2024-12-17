section .text
global check_word_complete

check_word_complete:
    ; rdi = address of guessed_word
    ; returns rax = 1 if complete, 0 if not

    push rdi
.loop_check:
    mov al, [rdi]
    cmp al, 0
    je .complete
    cmp al, '_'
    je .not_complete
    inc rdi
    jmp .loop_check

.complete:
    mov rax, 1
    pop rdi
    ret

.not_complete:
    mov rax, 0
    pop rdi
    ret
