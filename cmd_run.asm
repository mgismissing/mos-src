cmd_run_exit:
    cmp byte [boot_safe_mode_status], 0x01
    je sm_system_shutdown_screen
    jmp system_shutdown_screen

cmd_run_help:
    m_scr_cursor_print_string .str_general1, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_general2, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_general3, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_general4, 0x0F

    mov byte [cmd_run_finish_code], 0x00
    jmp cmd_run_global_return

    .str_general1: db 'Name     Description', 0
    .str_general2: db 'exit     Shuts down the computer', 0
    .str_general3: db 'help     Shows this menu', 0
    .str_general4: db 'test     Executes some tests', 0

cmd_run_test:
    .color_init:
    m_scr_cursor_print_string .str_test1_1, 0x0F
    m_scr_cursor_print_crlf
    mov byte [.var_newline_counter], 0x00
    mov bx, 0x00
    .color_loop:
    cmp bx, 0x0100
    je .color_end
    cmp byte [.var_newline_counter], 0x10
    jl .color_main
    mov byte [.var_newline_counter], 0x00
    m_scr_cursor_print_crlf
    .color_main:
    mov al, 'X'
    call scr_cursor_print_char
    inc bx
    inc byte [.var_newline_counter]
    jmp .color_loop
    .color_end:
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_test_continue, 0x0F
    call kb_waitForKey
    mov dx, 0x0007
    call scr_clear

    .charset_init:
    m_scr_cursor_print_string .str_test2_1, 0x0F
    m_scr_cursor_print_crlf
    mov byte [.var_newline_counter], 0x00
    mov ax, 0x00
    .charset_loop:
    cmp ax, 0x0100
    je .charset_end
    cmp ax, 0x000A
    je .charset_skip
    cmp ax, 0x000D
    je .charset_skip
    cmp byte [.var_newline_counter], 0x10
    jl .charset_main
    mov byte [.var_newline_counter], 0x00
    push ax
    m_scr_cursor_print_crlf
    pop ax
    .charset_main:
    mov bl, 0x0F
    push ax
    call scr_cursor_print_char
    pop ax
    inc ax
    inc byte [.var_newline_counter]
    jmp .charset_loop
    .charset_skip:
    push ax
    m_scr_cursor_print_char 'X', 0x0C
    pop ax
    inc ax
    inc byte [.var_newline_counter]
    jmp .charset_loop
    .charset_end:
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_test_continue, 0x0F
    call kb_waitForKey
    m_scr_cursor_print_crlf

    mov byte [cmd_run_finish_code], 0x00
    jmp cmd_run_global_return

    .str_test1_1: db '[1/2] Testing colors', 0
    .str_test2_1: db '[2/2] Testing charset', 0
    .str_test_continue: db 'Press any key to continue...', 0
    .var_newline_counter: db 0x00

cmd_run_finish_code: db 0x00

cmd_run_global_return:
    m_scr_cursor_print_crlf
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_program_end, 0x0E
    m_scr_cursor_print_char '0', 0x0E
    m_scr_cursor_print_crlf
    jmp cmd_main.prompt

    .str_program_end: db 'Program ended with code ', 0