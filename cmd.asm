cmd_start:
    call scr_init
    mov dx, 0x0007
    call scr_clear
    mov cx, 0x000F
    call scr_cursor_enable
    call scr_vga_disable_blinking
    jmp cmd_main

cmd_main:
    .start:
    m_scr_cursor_print_string cmdstr_welcome1, 0x0F
    m_scr_cursor_print_crlf
    mov bl, 0x0E
    mov ax, global_end
    mov al, ah
    call scr_cursor_print_hex
    mov bl, 0x0E
    mov ax, global_end
    call scr_cursor_print_hex
    m_scr_cursor_print_char '/', 0x0F 
    mov bl, 0x0E
    mov ax, 0xFFFF
    mov al, ah
    call scr_cursor_print_hex
    mov bl, 0x0E
    mov ax, 0xFFFF
    call scr_cursor_print_hex
    m_scr_cursor_print_string cmdstr_welcome2, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string cmdstr_welcome3, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string cmdstr_welcome4, 0x0F
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
    cmp al, '-'
    je .show_letter

    ; length filter
    cmp di, cmdvar_command + 63
    jg .loop

    cmp al, 'a'
    jl .loop
    cmp al, 'z'
    jg .loop
    sub al, ('a' - 'A')     ; make the letter uppercase

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
    call scr_vga_disable_blinking

    ; COMMANDS
    ; NONE
    mov si, cmdstr_cmd_none
    mov di, cmdvar_command
    call cmd_check_if_command
    jc .start
    
    ; DUMP
    mov si, cmdstr_cmd_dump
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_help.cmd_dump
    
    ; DUMP -M
    mov si, cmdstr_cmd_dump_memory
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_dump_memory

    ; DUMP -R
    mov si, cmdstr_cmd_dump_registers
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_dump_registers

    ; HELP
    mov si, cmdstr_cmd_help
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_help
    ; HELP DUMP
    mov si, cmdstr_cmd_help_dump
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_help.cmd_dump
    ; HELP HELP
    mov si, cmdstr_cmd_help_help
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_help.cmd_help
    ; HELP MOS
    mov si, cmdstr_cmd_help_mos
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_help.cmd_mos
    ; HELP SHUTDOWN
    mov si, cmdstr_cmd_help_shutdown
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_help.cmd_shutdown
    ; HELP TEST
    mov si, cmdstr_cmd_help_test
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_help.cmd_test

    ; MOS
    mov si, cmdstr_cmd_mos
    mov di, cmdvar_command
    call cmd_check_if_command
    jc extended_space_load

    ; SHUTDOWN
    mov si, cmdstr_cmd_shutdown
    mov di, cmdvar_command
    call cmd_check_if_command
    jc cmd_run_shutdown

    ; TEST
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

cmdstr_welcome1: db 'MagnesiumOS v0.8 Command Prompt', 0
cmdstr_welcome2: db ' Bytes Used', 0
cmdstr_welcome3: db 'Made with ', 0x03, ' by Gabriele Graziani', 0
cmdstr_welcome4: db 'Type "HELP" for a list of commands.', 0

cmdstr_prompt: db '> ', 0

cmdstr_cmd_missing: db '": No such command', 0

cmdstr_cmd_dump: db 'DUMP', 0
cmdstr_cmd_dump_memory: db 'DUMP -M', 0
cmdstr_cmd_dump_registers: db 'DUMP -R', 0
cmdstr_cmd_help: db 'HELP', 0
cmdstr_cmd_help_dump: db 'HELP DUMP', 0
cmdstr_cmd_help_shutdown: db 'HELP SHUTDOWN', 0
cmdstr_cmd_help_help: db 'HELP HELP', 0
cmdstr_cmd_help_mos: db 'HELP MOS', 0
cmdstr_cmd_help_test: db 'HELP TEST', 0
cmdstr_cmd_mos: db 'MOS', 0
cmdstr_cmd_shutdown: db 'SHUTDOWN', 0
cmdstr_cmd_test: db 'TEST', 0

cmdstr_cmd_none: db '', 0

%include "cmd_run.asm"