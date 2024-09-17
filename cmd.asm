cmd_start:
    call scr_init
    mov dx, 0x0007
    call scr_clear
    mov cx, 0x000F
    call scr_cursor_enable
    jmp cmd_main

cmd_main:
    .start:
    m_scr_cursor_print_string cmdstr_welcome1, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string cmdstr_welcome2, 0x0F
    m_scr_cursor_print_crlf
    .prompt:
    mov dx, 0x1800
    call scr_cursor_set_pos
    m_scr_cursor_print_string cmdstr_prompt, 0x0F
    call cmd_clear_command
    mov di, cmdvar_command
    .loop:
    mov cx, 0x01
    call kb_waitForKey

    cmp ah, 0x1C    ; Enter
    je .run

    ; Backspace handling
    cmp ah, 0x0E
    je .backspace

    ; Is it a valid letter?
    cmp al, ' '
    je .show_letter

    ; length filter
    cmp di, cmdvar_command + 63
    jg .loop

    cmp al, 'a'
    jl .loop
    cmp al, 'z'
    jg .loop

    jmp .show_letter
    .show_letter:
    ; add letter to buffer
    mov [di], al
    inc di

    ; add letter to screen
    mov bx, 0x000B
    call scr_cursor_print_char
    jmp .loop
    .show_letter_special:
    mov bx, 0x0000
    call scr_cursor_print_char_special
    jmp .loop
    .backspace:
    call scr_cursor_get_pos
    cmp dl, 2
    jle .loop

    ; remove letter from buffer
    dec di
    mov byte [di], 0

    ; remove letter from screen
    mov cx, 0x0001
    m_scr_cursor_print_char_special 0x08
    m_scr_cursor_print_char 0x00, 0x07
    m_scr_cursor_print_char_special 0x08
    jmp .loop

    .run:
    mov dx, 0x0007
    call scr_clear
    mov cx, 0x000F
    call scr_cursor_enable

    mov si, cmdstr_cmd_exit
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_exit

    mov si, cmdstr_cmd_help
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_help

    mov si, cmdstr_cmd_test
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_test

    m_scr_cursor_print_char '"', 0x0C
    m_scr_cursor_print_string cmdvar_command, 0x0C
    m_scr_cursor_print_string cmdstr_cmd_missing, 0x0C
    m_scr_cursor_print_crlf
    jmp .prompt

cmd_end:
jmp $

cmd_clear_command:
    mov di, cmdvar_command + 63
    .loop:
    cmp di, cmdvar_command
    jl cmd_global_return
    mov byte [di], 0
    dec di
    jmp .loop

cmd_check_if_command:                           ; cmd_check_if_command(si > Command String Pointer, di > User Input String Pointer) => cf > Equal
    .loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .notequal

    cmp al, 0
    je .done

    inc di
    inc si
    jmp .loop

    .notequal:
    clc
    ret

    .done:
    stc
    ret

cmd_global_return: ret

cmdvar_command: times 64 db 0
cmdvar_command_end: db 0

cmdstr_welcome1: db 'MagnesiumOS Command Prompt', 0
cmdstr_welcome2: db 'Made with ', 0x03, ' by Gabriele Graziani', 0
cmdstr_prompt: db '> ', 0

cmdstr_cmd_missing: db '": No such command', 0

cmdstr_cmd_exit: db 'exit', 0
cmdstr_cmd_help: db 'help', 0
cmdstr_cmd_test: db 'test', 0

%include "cmd_run.asm"