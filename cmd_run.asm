cmd_run_dump_memory:
    .start1:
    m_scr_cursor_print_string .str_loop1, 0x0E
    m_scr_cursor_print_crlf
    mov word [.var_mem], 0x7C00
    mov si, [.var_mem]
    mov dl, 0x00
    .startline1:
    cmp si, 0x7D00
    jge .start2
    pusha
    m_scr_cursor_print_string .str_hex_prefix, 0x0F
    mov bl, 0x0F
    mov ax, [.var_mem]
    mov al, ah
    call scr_cursor_print_hex
    mov bl, 0x0F
    mov ax, [.var_mem]
    call scr_cursor_print_hex
    m_scr_cursor_print_char ' ', 0x0F
    popa
    .loop1:
    mov bl, 0x0D
    mov al, [si]
    call scr_cursor_print_hex
    m_scr_cursor_print_char ' ', 0x0F
    inc si
    inc dl
    inc word [.var_mem]
    cmp dl, 0x10
    je .newline1
    jmp .loop1
    .newline1:
    mov dl, 0x00
    pusha
    m_scr_cursor_print_crlf
    popa
    jmp .startline1


    
    .start2:
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_continue, 0x0F
    call kb_waitForKey
    mov dx, 0x0007
    call scr_clear
    mov cx, 0x000F
    call scr_cursor_enable
    call scr_vga_disable_blinking

    m_scr_cursor_print_string .str_loop2, 0x0E
    m_scr_cursor_print_crlf
    mov word [.var_mem], 0x7D00
    mov si, [.var_mem]
    mov dl, 0x00
    .startline2:
    cmp si, 0x7E00
    jge .start3
    pusha
    m_scr_cursor_print_string .str_hex_prefix, 0x0F
    mov bl, 0x0F
    mov ax, [.var_mem]
    mov al, ah
    call scr_cursor_print_hex
    mov bl, 0x0F
    mov ax, [.var_mem]
    call scr_cursor_print_hex
    m_scr_cursor_print_char ' ', 0x0F
    popa
    .loop2:
    mov bl, 0x0D
    mov al, [si]
    call scr_cursor_print_hex
    m_scr_cursor_print_char ' ', 0x0F
    inc si
    inc dl
    inc word [.var_mem]
    cmp dl, 0x10
    je .newline2
    jmp .loop2
    .newline2:
    mov dl, 0x00
    pusha
    m_scr_cursor_print_crlf
    popa
    jmp .startline2


    
    .start3:
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_continue, 0x0F
    call kb_waitForKey
    mov dx, 0x0007
    call scr_clear
    mov cx, 0x000F
    call scr_cursor_enable
    call scr_vga_disable_blinking

    m_scr_cursor_print_string .str_loop3, 0x0E
    m_scr_cursor_print_crlf
    mov word [.var_mem], 0x7E00
    mov si, [.var_mem]
    mov dl, 0x00
    .startline3:
    cmp si, 0x7F00
    jge .end
    pusha
    m_scr_cursor_print_string .str_hex_prefix, 0x0F
    mov bl, 0x0F
    mov ax, [.var_mem]
    mov al, ah
    call scr_cursor_print_hex
    mov bl, 0x0F
    mov ax, [.var_mem]
    call scr_cursor_print_hex
    m_scr_cursor_print_char ' ', 0x0F
    popa
    .loop3:
    mov bl, 0x0D
    mov al, [si]
    call scr_cursor_print_hex
    m_scr_cursor_print_char ' ', 0x0F
    inc si
    inc dl
    inc word [.var_mem]
    cmp dl, 0x10
    je .newline3
    jmp .loop3
    .newline3:
    mov dl, 0x00
    pusha
    m_scr_cursor_print_crlf
    popa
    jmp .startline3

    .end:
    mov byte [cmd_run_finish_code], 0x00
    jmp cmd_run_global_return

    .var_mem: dw 0x0000

    .str_hex_prefix: db '0x', 0
    .str_continue: db 'Press any key to continue...', 0
    .str_loop1: db 'Memory dump of address 0x7C00 - 0x7D00:', 0
    .str_loop2: db 'Memory dump of address 0x7D00 - 0x7E00:', 0
    .str_loop3: db 'Memory dump of address 0x7E00 - 0x7F00:', 0

cmd_run_dump_registers:
    mov [.var_ax], ax
    mov [.var_bx], bx
    mov [.var_cx], cx
    mov [.var_dx], dx
    ; AX
    m_scr_cursor_print_string .reg_ax, 0x0F
    mov al, [.var_ax]
    mov [.buf], al
    m_scr_cursor_print_hex [.buf], 0x0D

    mov al, [.var_ax + 1]
    mov [.buf], al
    m_scr_cursor_print_hex [.buf], 0x0D
    m_scr_cursor_print_crlf

    ; BX
    m_scr_cursor_print_string .reg_bx, 0x0F
    mov al, [.var_bx]
    mov [.buf], al
    m_scr_cursor_print_hex [.buf], 0x0D

    mov al, [.var_bx + 1]
    mov [.buf], al
    m_scr_cursor_print_hex [.buf], 0x0D
    m_scr_cursor_print_crlf

    ; CX
    m_scr_cursor_print_string .reg_cx, 0x0F
    mov al, [.var_cx]
    mov [.buf], al
    m_scr_cursor_print_hex [.buf], 0x0D

    mov al, [.var_cx + 1]
    mov [.buf], al
    m_scr_cursor_print_hex [.buf], 0x0D
    m_scr_cursor_print_crlf

    ; DX
    m_scr_cursor_print_string .reg_dx, 0x0F
    mov al, [.var_dx]
    mov [.buf], al
    m_scr_cursor_print_hex [.buf], 0x0D

    mov al, [.var_dx + 1]
    mov [.buf], al
    m_scr_cursor_print_hex [.buf], 0x0D
    m_scr_cursor_print_crlf

    mov byte [cmd_run_finish_code], 0x00
    jmp cmd_run_global_return

    .buf: db 0x00
    .reg_ax: db 'AX: 0x', 0
    .reg_bx: db 'BX: 0x', 0
    .reg_cx: db 'CX: 0x', 0
    .reg_dx: db 'DX: 0x', 0

    .var_ax: dw 0x0000
    .var_bx: dw 0x0000
    .var_cx: dw 0x0000
    .var_dx: dw 0x0000

cmd_run_help:
    m_scr_cursor_print_string .str_general1, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_general2, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_general3, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_general4, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_general5, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_general6, 0x0F
    jmp .return

    .cmd_dump:
    m_scr_cursor_print_string .str_cmd_dump1, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_cmd_dump2, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_cmd_dump3, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_cmd_dump4, 0x0F
    m_scr_cursor_print_crlf
    jmp .return

    .cmd_help:
    m_scr_cursor_print_string .str_cmd_help1, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_cmd_help2, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_cmd_help3, 0x0F
    m_scr_cursor_print_crlf
    m_scr_cursor_print_string .str_cmd_help4, 0x0F
    m_scr_cursor_print_crlf
    jmp .return

    .cmd_mos:
    m_scr_cursor_print_string .str_cmd_mos1, 0x0F
    m_scr_cursor_print_crlf
    jmp .return

    .cmd_shutdown:
    m_scr_cursor_print_string .str_cmd_shutdown1, 0x0F
    m_scr_cursor_print_crlf
    jmp .return

    .cmd_test:
    m_scr_cursor_print_string .str_cmd_test1, 0x0F
    m_scr_cursor_print_crlf
    jmp .return

    .return:
    mov byte [cmd_run_finish_code], 0x00
    jmp cmd_run_global_return

    .str_general1: db 'Name             Description', 0
    .str_cmd_dump1:
    .str_general2: db 'DUMP [RESOURCE]  Dumps a specified resource', 0
    .str_cmd_help1:
    .str_general3: db 'HELP (COMMAND)   Shows help for the specified command', 0
    .str_cmd_mos1:
    .str_general4: db 'MOS              Executes MagnesiumOS', 0
    .str_cmd_shutdown1:
    .str_general5: db 'SHUTDOWN         Shuts down the computer', 0
    .str_cmd_test1:
    .str_general6: db 'TEST             Executes some tests', 0

    .str_cmd_dump2: db 'RESOURCE:', 0
    .str_cmd_dump3: db '    -M          Shows the RAM', 0x27, 's content from address 0x7C00 to 0x7FFF', 0
    .str_cmd_dump4: db '    -R          Shows the registers', 0x27, ' content', 0

    .str_cmd_help2: db 'COMMAND:', 0
    .str_cmd_help3: db '    Any         Shows specific help about the given command', 0
    .str_cmd_help4: db '    None        Shows the generic help page', 0

cmd_run_shutdown:
    jmp system_shutdown_screen

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
    mov cx, 0x000F
    call scr_cursor_enable
    call scr_vga_disable_blinking

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