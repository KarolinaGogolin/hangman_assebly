; ************************************************************
; Some data declarations
section .data
; Define constants
    EXIT_SUCCESS equ 0 ; successful operation
    SYS_exit equ 60 ; call code for terminate
    guesses_left db 7
    incorrect_chars_arr db "Incorrect guesses: ",0,0,0,0,0,0,0,10,0 ; the amount of 0 should match the guesses_left (at initialisation) + null terminator
    incorrect_chars_l equ $-incorrect_chars_arr

    ; ANSI escape codes for coloring (0x1B = ESC, [... = control sequence)
    ; green color
    green_color db 0x1B,'[32m',0
    green_color_len equ $-green_color

    ; red color
    red_color db 0x1B,'[31m',0
    red_color_len equ $-red_color

    ; restore color
    restore_color db 0x1B,'[0m',0
    restore_color_len equ $-restore_color

    ; clear console msg
    clear_console_msg db 0x1B,'[2J',0
    clear_console_msg_len equ $-clear_console_msg

    ; win msg
    win_msg db "Congratulations! You guessed the word!",10,13,0
    win_msg_len equ $-win_msg
    
    ; lose msg
    lose_msg db "You ran out of attempts! Game over!",10,13,0
    lose_msg_len equ $-lose_msg

    ; end game msg
    end_msg db "Thanks for playing. Goodbye!",10,13,0
    end_msg_len equ $-end_msg

section .bss
     secret_word resb 8 ; reserving 8 bytes to store the address of the secret word
     guessed_word resb 20
     curr_guessed_char resb 8 ; reserving 8 bytes to store the address of the guessed char

section .text
global _start
; Declare the external function
extern read_secret_function 
extern print_instruction
extern read_guess
extern process_guess
extern initialise_guessed_word
extern update_incorrect_guesses
extern print_ascii_art
extern check_word_complete
extern restart_or_exit
extern clear_incorrect_chars_arr

_start:
; Getting the word to guess from the user
;-------------------------------------------------------
call read_secret_function
mov [secret_word],rax ; putting the functions result into secret_word variable

; clearing console after reading secret word
lea rsi, [clear_console_msg]
mov rdx, clear_console_msg_len
call print_instruction

; Initialising the guess word
;-------------------------------------------------------
mov rdi, [secret_word]
lea rsi, [guessed_word]
call initialise_guessed_word

; Printing the initial game state (incl. state of the guessed word, incorrectly guessed characters and the state of hangman)
;-------------------------------------------------------
lea rsi, [incorrect_chars_arr]
mov rdx, incorrect_chars_l
call print_instruction

lea rsi, [guessed_word]
mov rdx, 20                
call print_instruction

mov rdi, 7
movzx rax, byte[guesses_left] ; loading a byte of guesses left into rax to zero extend it
sub rdi, rax
call print_ascii_art

NextGuess:

; Getting the guess from the user
;-------------------------------------------------------
call read_guess
mov [curr_guessed_char],rax

; clearing console after user makes the guess
lea rsi, [clear_console_msg]
mov rdx, clear_console_msg_len
call print_instruction

; Processing the guess (comparing it with the secret word and updating the curr_guessed_char_arr and guesses_left)
;-------------------------------------------------------
mov rdi, [secret_word]
lea rsi, [guessed_word]
mov rdx, [curr_guessed_char]
movzx rcx, byte[guesses_left]
call process_guess

; if the guess was correct then there is no need to update the incorrect_chars_arr and guesses left
cmp rax, 1
je CorrectGuess
           
lea rdi, [incorrect_chars_arr]
mov rax, [curr_guessed_char]     ; curr_guessed_char is a pointer to the value
movzx rsi, byte [rax] 
lea rdx, [guesses_left]
call update_incorrect_guesses

; Printing updated game status (hangman,incorrect guesses, guessed word)
;-------------------------------------------------------
CorrectGuess:
lea rsi, [incorrect_chars_arr]
mov rdx, incorrect_chars_l
call print_instruction

lea rsi, [guessed_word]
mov rdx, 20                
call print_instruction

mov rdi, 7
movzx rax, byte[guesses_left] ; loading a byte of guesses left into rax to zero extend it
sub rdi, rax
call print_ascii_art

; Checking if the game was lost, won or should continue
;-------------------------------------------------------
lea rdi, [guessed_word]
call check_word_complete

cmp rax, 1
je GameWon

cmp byte[guesses_left],0
je GameLost

jmp NextGuess

; Displaying message for a winner :D
;-------------------------------------------------------
GameWon:
lea rsi, [green_color]
mov rdx, green_color_len
call print_instruction

lea rsi, [win_msg]
mov rdx, win_msg_len
call print_instruction

lea rsi, [restore_color]
mov rdx, restore_color_len
call print_instruction
jmp EndGame

; Displaying message for a loser :c
;-------------------------------------------------------
GameLost:
lea rsi, [red_color]
mov rdx, green_color_len
call print_instruction

lea rsi, [lose_msg]
mov rdx, lose_msg_len
call print_instruction

lea rsi, [restore_color]
mov rdx, restore_color_len
call print_instruction
jmp EndGame

; Asking the user whether to restart the game or quit
;-------------------------------------------------------
EndGame:

lea rdi, [incorrect_chars_arr]
call clear_incorrect_chars_arr

call restart_or_exit
mov [guesses_left],rax
cmp byte[guesses_left], 7
je _start

lea rsi, [end_msg]
mov rdx, end_msg_len
call print_instruction

mov rax, SYS_exit       ; Call code for exit
mov rdi, EXIT_SUCCESS   ; Exit program with success
syscall
