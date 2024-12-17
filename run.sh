#!/bin/bash

# Set the names of the files
FILES="main.asm read_secret_function.asm is_valid_input.asm is_valid_length.asm print_instruction.asm to_lower_case_function.asm clear_buffer.asm read_guess.asm process_guess.asm initialise_guessed_word.asm update_incorrect_guesses.asm print_ascii_art.asm check_word_complete.asm"
OUTPUT_FILES="main.o is_valid_input.o is_valid_length.o print_instruction.o read_secret_function.o to_lower_case_function.o clear_buffer.o read_guess.o process_guess.o initialise_guessed_word.o update_incorrect_guesses.o print_ascii_art.o check_word_complete.o" #explicitly doing that cause we have other files with .o that we used for testing so cant to *.o and im too lazy to put them somewhere else
PROGRAM="hangman"

# Compilation and linking options
ASM_FLAGS="-g dwarf2 -f elf64" # Yasm assembly flags (64-bit and debug info)
LD_FLAGS="-g"                 # Linker flags (include debug info)

echo "Assembling source files..."
for file in $FILES; do
    obj_file="${file%.asm}.o"
    lst_file="${file%.asm}.lst"
    echo "Assembling $file -> $obj_file and generating listing $lst_file..."
    yasm $ASM_FLAGS -o "$obj_file" "$file" -l "$lst_file"
    if [ $? -ne 0 ]; then
        echo "Error assembling $file. Exiting."
        exit 1
    fi
done

# Step 2: Linking the object file
echo "Linking to create $PROGRAM..."
ld "$LD_FLAGS" -o "$PROGRAM" $OUTPUT_FILES
if [ $? -ne 0 ]; then
    echo "Error during linking. Exiting."
    exit 1
fi

# Step 3: Running or Debugging
if [ "$1" == "ddd" ]; then
    echo "Starting debugger..."
    ddd $PROGRAM
else
    if [ "$1" == "gdb" ]; then
    echo "Starting debugger..."
    gdb $PROGRAM
    else
    echo "Running $PROGRAM..."
    ./$PROGRAM
    fi
fi
