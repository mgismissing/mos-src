start_bsod:                             ; start_bsod(error_t, error_d) => None
    mov ax, 0x0000
    mov bx, SCR_SIZE
    mov dh, 0x00
    mov dl, 0x1F
    call boot_scr_draw_line

    mov ax, 0x0000
    mov dl, 0x1F
    mov bx, [error_t]
    call boot_scr_print_string

    mov ax, SCR_WIDTH
    mov dl, 0x1F
    mov bx, [error_d]
    call boot_scr_print_string

    mov ax, SCR_WIDTH * 3
    mov dl, 0x1F
    mov bx, boot_error_help1
    call boot_scr_print_string

    ret
start_extended_bsod:                    ; start_extended_bsod(error_t, error_d) => None
    mov ax, 0x0000
    mov bx, SCR_SIZE
    mov dh, 0x00
    mov dl, 0x1F
    call boot_scr_draw_line

    mov ax, SCR_WIDTH
    mov dl, 0x1F
    mov bx, [error_t]
    call boot_scr_print_string

    mov ax, SCR_WIDTH * 2
    mov dl, 0x1F
    mov bx, [error_d]
    call boot_scr_print_string

    mov ax, SCR_WIDTH * 4
    mov dl, 0x1F
    mov bx, error_help1
    call boot_scr_print_string
    mov ax, SCR_WIDTH * 5
    mov dl, 0x1F
    mov bx, error_help2
    call boot_scr_print_string

    mov ax, SCR_WIDTH * 7
    mov dl, 0x1F
    mov bx, error_help3
    call boot_scr_print_string
    mov ax, SCR_WIDTH * 8
    mov dl, 0x1F
    mov bx, error_help4
    call boot_scr_print_string

    mov ax, SCR_WIDTH * 9
    mov dl, 0x1F
    mov bx, error_help5
    call boot_scr_print_string

    ret