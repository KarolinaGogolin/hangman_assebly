# Hangman on Assembly

## Functional/High Level Design of the Project

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
- Convert to uppercase (or lowercase)

3. Game Logic

- Character matching:
  - loop through secret word to check if there's a match
  - update guessed word array if there's a match
  - if no match, decrement attempts
- Win condition: check if guessed word matches secret word
- Lose conditionL check if remaining attempts reach zero

4. Output Handling

- Display current state:
  - show guessed word with underscore for unguessed letters
  - show incorrect guesses and remaining attempts
- Game over msg: display "You Win!" or "You Lose!" with correct word

### Pseudocoude/Algorithm

``` text
START:
    // Initialization
    Load secret word into memory
    Initialize guessed word array with underscore
    Initialize incorrect guesses array
    Set remaining attempts to N

MAIN_LOOP:
    // Display state
    Print guessed word
    Print incorrect guesses
    Print remaining attempts

    // Get input
    Read char from user
    Convert to uppercase (or lowercase)

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

### Functions of the game

# NEED OPINION ON THIS

Below you will find a functions that we need to implement/teset for this game.
### 0.1 .data- initialised data
equ values: array_size(s) for the input word array and guessed array <br>
other vars: current_guessed -> initialised with the array_size and filled out with _ <br>
            letters_guessed -> two options: <br>
                                    1) initialise an array of bools and set all to true, when letter is guessed the corresponding index turns true
                                        pros: easier to implement, no dynamic memory menagement, lookup time O(1)
                                        cons: less compact, not as intuitive since we are not directly storing the letters
                                    2) an array of chars that has letters appended after each guess
                                        pros: more straight forward since it actually stores the letters used and not their indexes/ascii values, can be more                                                    compact then the first option (but not necessarily)
                                        cons: would require dynamic memory allocation which would be harder to implement, the lookup time complexity = O(n)

### 0.2 .bss- unitialised data
magic_word(or whatever better name we come up with) that will be initialised when the user inputs a valid word on keyboard
1. Initialization

- [ ] `init_game_state`: set up initial game vars
- [x] `read_secret`: read secret from user (use `read_char` as potential template) KAROLINA
- [x] `validate_secret`: ensure that secret is valid (use `validate_char` as potential template) KAROLINA
  - eng only
  - no num, symb and basically anything that is not alphabetical letter
- [x] `convert_to_lower`: convert secret to uppercase KAROLINA
- [x] `load_secret`: load secret into mem KAROLINA

2. Input

- [ ] `read_char`: read char from user KAROLINA
- [ ] `validate_char`: ensure that char is valid (same as `validate_secret`) KAROLINA
- [ ] `convert_to_lower`: same function from input, but for char KAROLINA

3. Processing

- [ ] `process_guess`: check if char is in secret and update game state MADI
- [ ] `check_win`: cmp guess arr with secret MADI
- [ ] `check_lose`: check if attempts == 0 MADI

4. Ouput

- [ ] `display_game_state`: prints
  - guess arr (underscores)
  - incorrect arr
  - attempts left
  - ASCII art
- [ ] `display_end_msg`: display whether user won or lost, along secret
- [ ] `play_again`: ask user if they want to play again

5. Main Control

- [ ] `main_game_loop`:controls flow of game including,
  - repeated input
  - processing guesses
  - checking conditions
- [ ] `restart_or_exit`: handles restart or exit decision at the end of the game
