# Creating a Hangman Game on x86-64 Assembly

## Introduction

This tutorial will guide you through building a hangman game in x86-64 assembly language. We will use [YASM](http://yasm.tortall.net/) as our assembler and Linux system calls for I/O operations. The game will include functionality like word guessing, displaying the hangman stages, etc.

### What is Assembly?

Assembly language is a “low-level” language and provides the basic instructional interface to the computer processor. Assembly language is as close to the processor as you can get as a programmer. Programs written in a high-level language are translated into assembly language in order for the processor to execute the program. The high-level language is an abstraction between the language and the actual processor instructions.

Assembly language gives you direct control of the system's resources. This involves setting processor registers, accessing memory locations, and interfacing with other hardware elements. This requires a significantly deeper understanding of exactly how the processor and memory work.

### Why Assembly?

Here, we can rephrase the proposal we made to the teachers and maybe add something on top of it.

## Prerequisites

- Familiarity with x86-64 assembly.
- Basic understanding of Linux system calls.
- Installed YASM assembler and linker.
- Debugger (DDD or GDB)

## High Level Design of the Project

In order to actually make a working game, we broke it down into manageable components that align with the low level nature of the language. Below you will find a high level design to guide the implementation:

### Game Structure

1. Initialization

- Load secret word into memory
- Initialize game state variables (attemts remaining, guessed letters, etc.)

2. Main Game Loop

- Display current game state
- Take input from user
- Process input to update game state
- Check win or lose conditions

3. Game End

- Display result
- Restart or exit game

### Core Components

1. Data Storage

- Secret word: store as a null-terminated string
- Guessed word: maintain array to display progress
- Incorrect guesses: store gussed letters that aren't in the word
- Remaining attempts: keep counter for allowed wrong guesses

2. Input Handling

- Read single character from user **(creating buffer for inputs)**
- Convert to lowercase

3. Game Logic

- Character matching:
  - loop through secret word to check if there's a match
  - update guessed word array if there's a match
  - if no match, decrement attempts
- Win condition: check if guessed word matches secret word
- Lose condition: check if remaining attempts reach zero

4. Output Handling

- Display current state:
  - show guessed word with underscore for unguessed letters
  - show incorrect guesses
  - display ASCII art for remaining attempts
- Game over message: display "You Win!" or "You Lose!"

### Pseudocoude/Algorithm

``` text
START:
    // Initialization
    Load secret word into memory
    Initialize guessed word array with underscore
    Initialize incorrect guesses array
    Set remaining attempts to 7

MAIN_LOOP:
    // Display state
    Print guessed word
    Print incorrect guesses
    Print remaining attempts (ASCII art)

    // Get input
    Read char from user
    Convert to lowercase

    // Process guess
    If char is in secret word:
        Update guessed word
    Else:
        Add to incorrect guesses
        Decrement remaining attempts
    
    // Check end conditions
    If guessed word matches secret word:
        Print "You Win!"
        Print the secret word
        Jump to END
    Else:
        Print "You Lose!"
        Print the secret word
        Jump to END

    // Repeat
    Jump to MAIN_LOOP

END:
    // Game end
    Print "Play Again? (y/n)"
    Read user input
    If input == "y":
        Jump to START
    Exit
```

## Cheatsheet

Although it is assumed that the reader knows the Assembly syntax, not everyone remembers what each keyword represents. Therefore, we have comprimised a cheatsheat for you before showing the implementation of the game.

### Registers

| 64-bit | 32-bit | 16-bit | 8-bit  | Special Purpose for Functions | When Calling a Function  | When Writing a Function  |
|--------|--------|--------|--------|--------------------------------|--------------------------|--------------------------|
| rax    | eax    | ax     | ah, al | Return Value                  | Might be changed         | Use freely               |
| rbx    | ebx    | bx     | bh, bl |                              | Will not be changed       | Save before using!       |
| rcx    | ecx    | cx     | ch, cl | 4th integer argument          | Might be changed         | Use freely               |
| rdx    | edx    | dx     | dh, dl | 3rd integer argument          | Might be changed         | Use freely               |
| rsi    | esi    | si     | sil    | 2nd integer argument          | Might be changed         | Use freely               |
| rdi    | edi    | di     | sil    | 1st integer argument          | Might be changed         | Use freely               |
| rbp    | ebp    | bp     | bpl    | Frame Pointer                 | Maybe be careful         | Maybe be careful         |
| rsp    | esp    | sp     | spl    | Stack Pointer                 | Be very careful!         | Be very careful!         |
| r8     | r8d    | r8w    | r8b    | 5th integer argument          | Might be changed         | Use freely               |
| r9     | r9d    | r9w    | r9b    | 6th integer argument          | Might be changed         | Use freely               |
| r10    | r10d   | r10w   | r10b   |                              | Might be changed         | Use freely               |
| r11    | r11d   | r11w   | r11b   |                              | Might be changed         | Use freely               |
| r12    | r12d   | r12w   | r12b   |                              | Will not be changed       | Save before using!       |
| r13    | r13d   | r13w   | r13b   |                              | Will not be changed       | Save before using!       |
| r14    | r14d   | r14w   | r14b   |                              | Will not be changed       | Save before using!       |
| r15    | r15d   | r15w   | r15b   |                              | Will not be changed       | Save before using!       |

_"Might be changed" = "Caller saved"; "Will not be changed" = "Callee saved"._

### Basic Instructions

| Arithmetic       | Logic              | Jumps          | Stack         |
|------------------|--------------------|----------------|---------------|
| `add <dest> <src>` | `and <dest> <src>` | `jmp <label>`   | `call <label>` |
| `sub <dest> <src>` | `or <dest> <src>`  | `cmp <dest> <src>` | `ret`          |
| `inc <dest>`     | `not <dest>`       | `je <label>`    | `push <src>`   |
| `dec <dest>`     | `shr <dest>, <imm>`| `jne <label>`   | `pop <dest>`   |
| `imul <dest> <src>` | `shr <dest>, cl`  | `jg <label>`    |               |
| `div <dest>`     | `shl <dest>, <imm>`| `jge <label>`   |               |
|                  | `shl <dest>, cl`   | `jl <label>`    |               |
|                  | `sar <dest>, <imm>`| `jle <label>`   |               |
|                  | `sar <dest>, cl`   |                |               |

_`<dest>` is register or memory_\
_`<src>` is register or memory or immediate_\
_`<imm>` is immediate (byte only)_

### `mov` and `lea`

|   Instruction   |   Description                                                                                       |   Syntax                          |   Example                                  |   Notes                                                                                   |
|------------------|-----------------------------------------------------------------------------------------------------|-----------------------------------|--------------------------------------------|------------------------------------------------------------------------------------------|
| **`mov`**        | Copies data from a source operand to a destination operand.                                         | `mov <dest>, <src>`                   | `mov rax, rbx`                              | Transfers the value of `rbx` into `rax`.                                                |
|                  |                                                                                                     |                                   | `mov rax, [rbx]`                            | Loads the value at memory address in `rbx` into `rax`.                                   |
|                  |                                                                                                     |                                   | `mov [rbx], rax`                            | Stores the value of `rax` into the memory address in `rbx`.                              |
|                  | Copies immediate value to register or memory.                                                      |                                   | `mov rax, 5`                                | Sets `rax` to 5.                                                                         |
|                  | Moves data between memory and registers or between registers.                                       |                                   | `mov eax, dword [rbx]`                      | Loads a 32-bit value from memory into `eax`.                                             |
| **`lea`**        | Loads the effective address of the source operand into the destination register without accessing memory. | `lea <dest>, <src>`                   | `lea rax, [rbx+4]`                          | Loads address `rbx + 4` into `rax`.                                                     |
|                  | Useful for address arithmetic.                                                                      |                                   | `lea rax, [rbx+rcx*4]`                      | Computes `rbx + rcx*4` and stores the address in `rax`.                                  |
|                  |                                                                                                     |                                   | `lea rax, [rbx-8]`                          | Computes `rbx - 8` and stores the address in `rax`.                                      |
|                  |                                                                                                     |                                   | `lea rax, [label]`                          | Loads the address of `label` into `rax`.                                                |
|                  |                                                                                                     |                                   | `lea rax, [rsp+16]`                         | Adjusts the stack pointer address for use without modifying its value.                   |

## Functions of the game

Below you will find a list of functions that we have came with to implement the game. This list more or less follows the game structure/core components mentioned in the chapters above. However, during the implementation certain things have been modified. This is mostly because in higher level languages like C/C++, we do not have the privilege of using standard library functions. For example, to have the function equivalent to `printf` the `print_instruction` function has been created.

``` asm
section .text
    global print_instruction

print_instruction:
    mov rax, 1      ; sys_write system call
    mov rdi, 1      ; file descriptor 1 -> stdout
    syscall
ret
```

- `section .text` - declares `.text` section of the program, which contains the executable of the code.
- `global print_instruction` - declares `print_instruction` symbol as global, allowing it to be referenced by other files or the OS's linker.
- `print_instruction` - marks the beginning of the function.
- `mov rax, 1` - loads the number `1` to `rax` register. In Linux x86-64, the `syscall` instruction uses the `rax` register to specify the system call number. `1` corresponds to the `sys_write` system call.
- `mov rdi, 1` loads the number `1` to `rdi` register. The `rdi` register holds the first argument for the system call. For `sys_write`, the first argument specifies the file descriptor. A value of `1` indicates `stdout`.
- `syscall` - invokes the system call specified in `rax` (in this case, `sys_write`).
- `ret` - returns control to the caller of `print_instruction`. Pops the return address from the stack and jumps to it.

**Note:** Not every function will include the breakdown of each line nor its full implementation. We will generally focus on the important bits that are crucial to the program. If you are interested in finding out more about particular function, you can look at the comments in its file.

### 1. Initialization

``` asm
-------------------- main.asm --------------------
section .data
    guesses_left db 7
    incorrect_chars_arr db "Incorrect guesses: ",0,0,0,0,0,0,0,10,0
    incorrect_chars_l equ $-incorrect_chars_arr
    ; code...

section .bss
    secret_word resb 8
    guessed_word resb 20
    curr_guessed_char resb 8
    ; code...

section. text
    global _start
    extern initialise_guessed_word
    ; code...

_start:
    ; code...
    mov rdi, [secret_word]
    lea rsi, [guessed_word]
    call initialise_guessed_word

-------------------- initialise_guessed_word.asm --------------------
section .text 
    global initialise_guessed_word

initialise_guessed_word:
    xor rdx, rdx

    CheckLoop:
        mov al, byte[rdi+rdx]

        cmp al, 0
        jle Exit

        cmp al, 10
        je Exit

        mov byte[rsi+rdx], '_'

        inc rdx
        jmp CheckLoop
    
    Exit:
        ret
```

main.asm:

- `section .data` - stores initialized variables strings.
  - `guessed_left` - tracks the number of remaining guesses, starting with `7`. The reason why we have hardcoded this value, was because the ASCII art contains 7 drawings of hangman stages.
  - `incorrect_chars_arr` - a pre-initialized array with the text "Incorrect guesses: " followed by space for 7 additional characters (`0,0,0,0,0,0,0`) and a newline (`10`) at the end. The final `0` is a null terminator.
  - `incorrect_chars_l` - calculates the total length of `incorrect_chars_arr` at assembly time.
- `section .bss` - reserves space for variables that will initialized at runtime.
  - `secret_word` - reserving 8 bytes to store the address of the secret word.
  - `guessed_word` - reserves 20 bytes for the player's guessed progress.
  - `curr_guessed_char` - reserving 8 bytes to store the address of the guessed char.
- `extern initialise_guessed_word` - declares external function for linking.
- Code within `_start` initializes guessed word based on secret word.
  - `mov rdi, [secret_word]` - passes the address of `secret_word` as the first argument (source) to the function.
  - `lea rsi, [guessed_word]` - passes the adress of `guessed_word` as the second argument (destination) to the function.
  - `call initialise_guessed_word` - invokes the external function to populate `guessed_word`.

initialise_guessed_word.asm:

- Function logic:
  - `xor rdx, rdx` - clears the `rdx` register which will be used as a counter (index) for the loop.
  - `CheckLoop` - itirates through each character of `secret_word` and initializes `guessed_word` with underscores (`_`).
    - `mov al, byte[rdi+rdx]` - loads the current byte from `secret_word` into `al`.
    - `cmp al, 0` - checks if the current character is null-terminator. If so, exit the loop.
    - `cmp al, 10` - checks if the current character is newline. If so, exit the loop.
    - `mov byte[rsi+rdx], '_'` - writes an underscore to the corresponding position in `guessed_word`
    - `inc rdx` - increments the counter for the next character.
    - `jmp CheckLoop` - repeats the loop.
  - `Exit` - ends the function and returns control to the caller.

``` asm
-------------------- to_lower_case_function.asm --------------------


```

- text

### 2. Input

``` asm
-------------------- read_secret_function.asm --------------------


```

- text

``` asm
-------------------- read_guess.asm --------------------


```

- text

``` asm
-------------------- is_valid_input.asm --------------------


```

- text

``` asm
-------------------- is_valid_length.asm --------------------


```

- text

### 3. Processing

``` asm
-------------------- clear_buffer.asm --------------------


```

- text

``` asm
-------------------- main.asm --------------------
mov rdi, [secret_word]
lea rsi, [guessed_word]
mov rdx, [curr_guessed_char]
movzx rcx, byte[guesses_left]
call process_guess

-------------------- process_guess.asm --------------------
section .data
    already_guessed_mes db "This letter was already guessed!",10,0
    already_guessed_mes_l equ $-already_guessed_mes

section .text
global process_guess
extern print_instruction

process_guess:
    mov r8, 0

.loop:
    mov al, byte [rdi]
    cmp al, 10
    je .end

    cmp al, 0
    je .end

    cmp al, byte[rdx]
    jne .next

    cmp byte[rsi], al
    je .was_guessed

    mov byte [rsi], al
    mov r8, 1

.next:
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
```

- `mov r8, 0` - initializes the `r8` register to `0`. This register is used as a flag to indicate wheter the guessed letter was processed successfully (`1`) or not (`0`).
- `.loop` - iterates over the `secret_word` until newline or null-terminator is encountered.
  - `cmp al, byte[rdx]` - compares the current character of `secret_word` with the guessed character. If they do not match, proceed to the next character in the loop.
  - `cmp byte[rsi], al` - checks if the guessed character already exists in `secret_word`. If it does, jump to `.was_guessed`.
  - `mov byte[rsi], al` - adds the guessed character to the corresponding position in `guessed_word`. Sets the success flag to `1`.
- `.next` - moves to the next character in `secret_word`; moves to the next position in `guessed_word`; repeats the loop for the next character.
- `.was_guessed` - handles the case where the guessed character was already guessed.
- `.end` - exits the function and returns the flag in `rax`.

``` asm
-------------------- main.asm --------------------
lea rdi, [incorrect_chars_arr]
mov rax, [curr_guessed_char]
movzx rsi, byte [rax] 
lea rdx, [guesses_left]
call update_incorrect_guesses

-------------------- update_incorrect_guesses.asm --------------------
section .data
    already_guessed_mes db "This letter was already guessed!",10,0
    already_guessed_mes_l equ $-already_guessed_mes

section .text
global update_incorrect_guesses
extern print_instruction

update_incorrect_guesses:
    push rdi
    add rdi,19
    
.loop:
    cmp byte[rdi],0
    je .add_guess

    cmp byte[rdi], sil
    je .already_guessed

    inc rdi
    jmp .loop

.already_guessed:
    pop rdi
    lea rsi, [already_guessed_mes]
    mov rdx, already_guessed_mes_l
    call print_instruction
    ret

.add_guess:
    mov byte[rdi],sil
    dec dword [rdx]
    pop rdi
    ret
```

- `update_incorrect_guesses` - prepares for processing incorrect guesses.
  - `push rdi` - saves the value of `rdi` on the stack to restore it ltaer.
  - `add rdi, 19` - adjusts `rdi` to point to the start of the incorrect guesses section in memory (basically, skipping the "Incorrect guesses: " from main).
- `.loop` - iterates through the incorrect guesses array to check if the guessed letter is already present.
- `.already_guessed` - handles the case where the guessed letter is already in the incorrect guesses array.
  - `pop rdi` - restores the original value of `rdi`.
- `.add_guess` - adds the guessed letter to the incorrect guessed array and updates the remaining guesses counter.
  - `dec dword [rdx]` - decrements the number of guesses left.

**Note for `sil`**:

- it directly represents the guessed character as a single byte.
- it matches the expected input size for comparisons and assignments.
- it avoids unnecessary overhead that would arise from using the full `rsi` register

``` asm
-------------------- main.asm --------------------
lea rdi, [guessed_word]
call check_word_complete

-------------------- check_word_complete.asm --------------------
section .text
global check_word_complete

check_word_complete:
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
```

- `.loop_check` - iterates over the guessed word to check if it contains any underscores.
- `.complete` - handles the case where no underscores are found, and the word is complete.
- `.not_complete` - handles the case where an underscore is found, indicating the word is not yet complete.

### 4. Output

``` asm
lea rsi, [incorrect_chars_arr]
mov rdx, incorrect_chars_l
call print_instruction
```

- Prints the incorrect charracter array

``` asm
lea rsi, [guessed_word]
mov rdx, 20
call print_instruction
```

- Prints the guessed word

``` asm
mov rdi, 7
movzx rax, byte[guesses_left]
sub rdi, rax
call print_ascii_art
```

- Prints the state of the hangman.

``` asm
-------------------- print_ascii_art.asm --------------------
section .data
    stages dq stage1,stage2,stage3,stage4,stage5,stage6,stage7,stage8
    stage1 dw 10,"       ",10,"       ",10,"       ",10,"       ",10,"       ",10,"       ",10,"=========",10,0 ;putting spaces to ensure even lengths
    length equ $-stage1
    stage2 dw 10,"  +---+",10,"  |   |",10,"      |",10,"      |",10,"      |",10,"      |",10,"=========",10,0
    stage3 dw 10,"  +---+",10,"  |   |",10,"  O   |",10,"      |",10,"      |",10,"      |",10,"=========",10,0
    stage4 dw 10,"  +---+",10,"  |   |",10,"  O   |",10,"  |   |",10,"      |",10,"      |",10,"=========",10,0
    stage5 dw 10,"  +---+",10,"  |   |",10,"  O   |",10," /|   |",10,"      |",10,"      |",10,"=========",10,0
    stage6 dw 10,"  +---+",10,"  |   |",10,"  O   |",10," /|\  |",10,"      |",10,"      |",10,"=========",10,0
    stage7 dw 10,"  +---+",10,"  |   |",10,"  O   |",10," /|\  |",10," /    |",10,"      |",10,"=========",10,0
    stage8 dw 10,"  +---+",10,"  |   |",10,"  O   |",10," /|\  |",10," / \  |",10,"      |",10,"=========",10,0

section .text
global print_ascii_art
extern print_instruction

print_ascii_art:
    mov rax, rdi
    mov rsi, 8
    mul rsi
    lea rbx, [stages]
    add rax, rbx
    mov rax,[rax]
    lea rsi, [rax]
    mov rdx, length
    call print_instruction
    ret
```

- `stages dq ...` - an array of 8 quadword pointers that point to the memory location of each ASCII art stage.

``` asm
    mov rax, rdi
    mov rsi, 8
    mul rsi
```

- Calculates the offset of the desired stage in the `stages` array based on the number of incorrect guesses.

``` asm
section .data
    ; code...
    green_color db 0x1B,'[32m',0
    green_color_len equ $-green_color

    restore_color db 0x1B,'[0m',0
    restore_color_len equ $-restore_color

    win_msg db "Congratulations! You guessed the word!",10,13,0
    win_msg_len equ $-win_msg
    ; code...

_start:
; code...

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
; code...
```

- `0x1B` - ANSI code for `ESC`
- `[32m` - ANSI code for color green
- `[0m` - ANSI code for default color.
- Changes the message color to green.
- Prints the game win message in green.
- Restores the message color to default.

``` asm
section .data
    ; code...
    red_color db 0x1B,'[31m',0
    red_color_len equ $-red_color

    restore_color db 0x1B,'[0m',0
    restore_color_len equ $-restore_color

    lose_msg db "You ran out of attempts! Game over!",10,13,0
    lose_msg_len equ $-lose_msg
    ; code...

_start:
; code...

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
; code...
```

- `[31m` - ANSI code for color red.
- Changes the message color to red.
- Prints the game lose message in red.
- Restores the message color to default.

**Note:** if we do not restore the color back to default, any continous messages that will appear in console will be of color we set to previously (green or red).

``` asm
clear_console_msg db 0x1B,'[2J',0
clear_console_msg_len equ $-clear_console_msg

lea rsi, [clear_console_msg]
mov rdx, clear_console_msg_len
call print_instruction
```

- `[2J` - ANSI code for clearing (erasing) the entire console screen. It technically does not fully erase the contents of a screen. Newlines are added to simulate a clear console, so user can _cheat_ by scrolling up to view the secret word.

### 5. Main Control

``` asm
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
call print_instruction (incorrect_chars_arr)

call print_instruction (guessed_word)

mov rdi, 7
movzx rax, byte[guesses_left]
sub rdi, rax
call print_ascii_art (first state of hangman)

NextGuess:
; Getting the guess from the user
;-------------------------------------------------------
call read_guess
mov [curr_guessed_char],rax

; clearing console after user makes the guess

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
jmp EndGame

; Displaying message for a loser :c
;-------------------------------------------------------
GameLost:
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

call print_instruction (end_msg)

mov rax, SYS_exit       ; Call code for exit
mov rdi, EXIT_SUCCESS   ; Exit program with success
syscall
```

``` asm
-------------------- clear_incorrect_chars_arr.asm --------------------

```

- text

``` asm
-------------------- restart_or_exit.asm --------------------
section .data
   restart_msg db "Do you want to restart the game? (y/n)",10,13,0
   restart_msg_len equ $-restart_msg

   invalid_choice_msg db "Invalid choice. Please enter 'y' or 'n'",10,13,0
   invalid_choice_len equ $-invalid_choice_msg

   yes equ 'y'
   no equ 'n'

section .bss
   user_choice resb 1

section .text
   global restart_or_exit
   extern print_instruction
   extern read_guess

restart_or_exit:
   lea rsi, [restart_msg]
   mov rdx, restart_msg_len
   call print_instruction

   call read_guess

   cmp byte [rax], yes
   je .return_restart

   cmp byte [rax], no
   je .return_exit

   lea rsi, [invalid_choice_msg]
   mov rdx, invalid_choice_len
   call print_instruction
   jmp restart_or_exit

.return_restart
   mov rax, 7
   ret

.return_exit
   mov rax, 0
   ret
```

- `restart_or_exit` - function reads the user choice, and will act upon their choice. It will keep asking the user to make a choice until they give correct answer, which is `y` or `n`.
- `.return_restart` - when user choses `y` as an option, function returns `7`. The reason on why it returns `7` and not `1` like in other functions, is because the game allows seven guesses for player to make. In `main.asm`, after calling the function, we load `7` back to `guesses_left`.
- `.return_exit` - when user choses `n` as an option, function returns `0`.

## Compile and Run

Luckily for you, reader, there is a bash script `run.sh` which already assembles, links and runs the program for you!

``` bash
chmod +x run.sh
./run.sh
```

If you want to debug the program, simply add `DDD` or `GDB` arguments after `./run.sh`.

I dont think we need to actually include this bash script. Instead we can refer to the assembly book that has a nice skeleton of it already.

Sure, we can do that. I thought the chapter was quite short, because of that I included the script to make it a bit longer.

## Conclusion

You now have a working Hangman game in x86-64 assembly! You can extend it further by adding your own features, like inputting multiple words, improving graphical elements and others.
