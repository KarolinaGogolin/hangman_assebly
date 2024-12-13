; This function takes a string that the user input and clears it, then if the length of the input string is bigger than the buffer it also clears the stdin
; In case the passed length is 0, then the function does not clear the content that was passed in rdi but only clears stdin
; arguments: rdi -> the addres to users input - how much input should be cleared from the buffer
;            rsi -> the length of the buffer
; returns: nothing
section .bss
    temp_buffer resb 1      ; temp buffer for clearing stdin
    buffer_length resb 1    ; variable to store the buffer length passed in rsi
section .text
    global clear_buffer
    extern is_valid_length

clear_buffer:
    ;clearing the data within the buffers size 
    ;--------------------------------------
    cmp rsi,0               ; if the length to clear is 0 then jump straight to clearing stdin
    je OnlyClearStdin
    mov [buffer_length],rsi

    call is_valid_length    ; getting the length of the input string before clearing it
    ; cant remove is_valid_length cause it doesnt work correctly without it?????????????

    mov rcx,[buffer_length]
    rep stosb               ; this clears only the size of the buffer (if the user input more chars than buffer_length we will need to clear stdin)  

    cmp rdi,0
    je Exit
    ;---------------------------------------

    ; BITMASK:
    ; for monitoring files, to monitor stdin(0) the bitmask should be 1 for the corresponding bit -> 0001 so thats why push 1
    ; if i wanted to monitor stdout(1) i would have to make a bitmap like this: 0011 <- here im selecting bit0 for stdin and bit1 for stdout

    ; now using select syscall to see if there is any data in stdin ready to read
    ;---------------------------------------
    OnlyClearStdin:
    push 100000     ; time struct
    push 0          ; time struct
    mov r8, rsp     ; timeout = 0,1 sec (non blocking mode with timeout)


    push 1          ; bitmask for fd argument for select syscall; this makes rsp -= 8
    mov rdi, 1      ; nfds = 1 (file descriptor to monitor (0) + 1 = 1)
    mov rsi, rsp    ; fd   = 0 (bitmask of file to monitor)
    xor rdx, rdx    ; writefds = NULL
    xor r10, r10    ; exceptfds = NULL
    mov rax, 23     ; rax = 23 for select syscall
    syscall

    add rsp, 24     ; cleaning up the stack; rsp += 3*8 (back to before pushing)

    cmp rax,0       ; for select if rax == 0 then no data to read, if rax>0 means there is sth in stdin
    je Exit
    ;---------------------------------------

    ; clearing stdin
    ;---------------------------------------   
    mov rdi, 0                  ; stdin file descriptor
    lea rsi, [temp_buffer]      ; Temporary buffer for flushing
    mov rdx, 1                  ; Read one byte at a time
    FlushLoop:
    mov rax, 0                  ;setting up rax again because syscall changes it to 1
    syscall                     ; read which automatically moves the pointer to the next unread char
    cmp byte [temp_buffer], 10  ; If is not newline, jump back to loop
    jne FlushLoop
    Exit:
    ;---------------------------------------
ret

; This function takes a string that the user input and clears it, then if the length of the input string is equal or more than 20 it also clears the stdin
; arguments: rdi -> the addres to users input
; returns: nothing
; section .bss
;     temp_buffer resb 1 ;temp buffer for clearing stdin

; section .text
;     global clear_buffer
;     extern is_valid_length

; clear_buffer:

;     call is_valid_length ; getting the length of the input string before clearing it
;     mov rcx,20
;     rep stosb ; this clears only the size of the buffer (if the user input more than 20 chars we will need to clear stdin)

;     cmp rax,20 ; if the users input is smaller than 20 then it means stdin is empty -> jump to exit
;     jl Exit

;     ; mov rax, 0                  ; sys_read system call
;     mov rdi, 0                  ; stdin file descriptor
;     lea rsi, [temp_buffer]      ; Temporary buffer for flushing
;     mov rdx, 1                  ; Read one byte at a time
;     FlushLoop:
;     mov rax, 0                  ;setting up rax again because syscall changes it to 1
;     syscall                     ; read which automatically moves the pointer to the next unread char
;     ; cmp rax, 0                  ; check for null
;     ; je Exit
;     cmp byte [temp_buffer], 10  ; If is not newline, jump back to loop
;     jne FlushLoop
;     Exit:
; ret