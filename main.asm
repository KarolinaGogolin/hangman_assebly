; ************************************************************
; Some data declarations
section .data
; Define constants
    EXIT_SUCCESS equ 0 ; successful operation
    SYS_exit equ 60 ; call code for terminate
    guesses_left db 13

section .bss
     secret_word resb 20; reserving 20 bytes for the secret word
     guessed_word resb 20
     curr_guessed_char resb 1
     guessed_chars_arr resb 13; ??? verify how many tries we have
; -----

section .text
global _start
extern read_secret_function ; Declare the external function
extern print_instruction
extern read_guess
extern process_guess
extern initialise_guessed_word

_start:
; mov rdx, [temp2]
; mov rsi, [guessed_word]
; mov rdi, [temp1]
; call process_guess

; Getting the word to guess from the user
;-------------------------------------------------------
call read_secret_function
mov [secret_word],rax ;putting the functions result into secret_word variable

;printing the secret word returned from the function for debbuging purposes for now :)
mov rsi, [secret_word]
mov rdx, 20                 ; get the length of the string (excluding null terminator)
call print_instruction

; Initialising the guess word
;-------------------------------------------------------
mov rdi, [secret_word]
lea rsi, [guessed_word]
call initialise_guessed_word

;for debbuging
lea rsi, [guessed_word]
mov rdx, 20                 ; get the length of the string (excluding null terminator)
call print_instruction

; Getting the guess from the user
;-------------------------------------------------------
NextGuess:
call read_guess
mov [curr_guessed_char],rax

; ;printing current guess
; mov rsi, [curr_guessed_char]
; mov rdx, 1                 ; get the length of the string (excluding null terminator)
; call print_instruction

mov rdi, [secret_word]
lea rsi, [guessed_word]
mov rdx, [curr_guessed_char]
movzx rcx, byte[guesses_left]
call process_guess

mov byte[guesses_left], cl ; cl is the lower 8 bits of rcx

lea rsi, [guessed_word]
mov rdx, 20                 ; get the length of the string (excluding null terminator)
call print_instruction

;  printing current guess
mov rsi, '"10,13"
mov rdx, 1                 ; get the length of the string (excluding null terminator)
call print_instruction

cmp byte[guesses_left],0
jne NextGuess
; guesses_left is a raw int not an ascii :C
; movzx rsi, byte[guesses_left]  
; mov rdx, byte[guesses_left]              
; call print_instruction

; Exit system call
mov rax, SYS_exit       ; Call code for exit
mov rdi, EXIT_SUCCESS   ; Exit program with success
syscall

