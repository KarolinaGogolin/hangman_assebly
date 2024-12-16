section .data
    ; stage1 dw 10,10,10,10,10,10,10,"=========",10,0
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
    mov rax, rdi ;putting the index into rax
    mov rsi, 8; size of one index
    mul rsi
    lea rbx, [stages] ; loading base address
    add rax, rbx; rax = base address + index*8
    mov rax,[rax] ; derefernce rax
    lea rsi, [rax]
    mov rdx, length                
    call print_instruction
    ret
