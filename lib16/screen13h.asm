scr13_init:                                       ; scr13_init() => None
    mov ax, 0x0013
    int 0x10
    mov ax, 0xA000
    mov es, ax
    mov ax, 0x0000
    ret

scr13_pixel_set:                                  ; scr13_pixel_set(ax > Index, dl > Color) => None
    mov di, ax
    mov [es:di], dl
    ret
scr13_pixel_set_if:                               ; scr13_pixel_set_if(ax > Index, dl > Color, cf > Condition) => None
    jne .scr13_pixel_set_if_false
    call scr13_pixel_set
    .scr13_pixel_set_if_false:
    ret
scr13_pixel_get:                                  ; scr13_pixel_get(ax > Index) => dl > Color
    mov di, ax
    mov dl, [es:di]
    ret
scr13_draw_line:                                  ; scr13_draw_line(ax > Start, bx > End, dl > Color) => None
    cmp ax, bx
    je scr13_global_ret
    call scr13_pixel_set
    inc ax
    jmp scr13_draw_line

scr13_print_char_partof_str:                      ; scr13_print_char_partof_str(ax > Index, dl > Color, bx > Char) => None
    mov [scr13_print_char_partof_str_ax], ax
    mov [scr13_print_char_partof_str_bx], bx
    mov [scr13_print_char_partof_str_dl], dl
    call scr13_print_char
    mov ax, [scr13_print_char_partof_str_ax]
    mov bx, [scr13_print_char_partof_str_bx]
    mov dl, [scr13_print_char_partof_str_dl]
    add ax, 4
    ret

scr13_print_char:                                 ; scr13_print_char(ax > Index, dl > Color, bx > Char) => None
    mov byte [scr13_print_char_color], dl
    sub bx, 'A'
    mov cx, ax
    mov ax, 0x0004
    mul bx
    mov bx, ax
    mov ax, cx
    add bx, scr13_font_start
    mov byte [scr13_print_char_current_pixel_mask], 0b10000000
    mov byte [scr13_print_char_current_pixel], 0x00
    .scr13_print_char_loop1:
        mov cx, [bx]
        and cx, [scr13_print_char_current_pixel_mask]
        cmp cx, [scr13_print_char_current_pixel_mask]
        mov dl, [scr13_print_char_color]
        call scr13_pixel_set_if
        shr byte [scr13_print_char_current_pixel_mask], 1
        inc ax

        mov cx, [scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000011
        je .scr13_print_char_newline

        mov cx, [scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000111
        je .scr13_print_char_nextbyte
    .scr13_print_char_loop2:
        inc byte [scr13_print_char_current_pixel]
        cmp byte [scr13_print_char_current_pixel], 32
        jne .scr13_print_char_loop1
        ret
    
    .scr13_print_char_newline:
        add ax, SCR13_WIDTH - 4
        jmp .scr13_print_char_loop2

    .scr13_print_char_nextbyte:
        add ax, SCR13_WIDTH - 4
        inc bx
        mov byte [scr13_print_char_current_pixel_mask], 0b10000000
        jmp .scr13_print_char_loop2

scr13_global_ret: ret

scr13_print_char_partof_str_ax: dw 0x0000
scr13_print_char_partof_str_bx: dw 0x0000
scr13_print_char_partof_str_dl: db 0x00
scr13_print_char_current_pixel_mask: dw 0x0000
scr13_print_char_current_pixel: dw 0x0000
scr13_print_char_color: db 0x00

scr13_font_start:
scr13_font__A:
    db 0b00000100
    db 0b10101010
    db 0b11101010
    db 0b10100000
scr13_font__B:
    db 0b00001100
    db 0b10101100
    db 0b10101010
    db 0b11000000
scr13_font__C:
    db 0b00000110
    db 0b10001000
    db 0b10001000
    db 0b01100000
scr13_font__D:
    db 0b00001100
    db 0b10101010
    db 0b10101010
    db 0b11000000
scr13_font__E:
    db 0b00001110
    db 0b10001100
    db 0b10001000
    db 0b11100000
scr13_font__F:
    db 0b00001110
    db 0b10001100
    db 0b10001000
    db 0b10000000
scr13_font__G:
    db 0b00000110
    db 0b10001000
    db 0b10101010
    db 0b01100000
scr13_font__H:
    db 0b00001010
    db 0b10101110
    db 0b10101010
    db 0b10100000
scr13_font__I:
    db 0b00001110
    db 0b01000100
    db 0b01000100
    db 0b11100000
scr13_font__J:
    db 0b00001110
    db 0b00100010
    db 0b00100010
    db 0b11000000
scr13_font__K:
    db 0b00001010
    db 0b10101100
    db 0b10101010
    db 0b10100000
scr13_font__L:
    db 0b00001000
    db 0b10001000
    db 0b10001000
    db 0b11100000
scr13_font__M:
    db 0b00001010
    db 0b11101010
    db 0b10101010
    db 0b10100000
scr13_font__N:
    db 0b00001100
    db 0b10101010
    db 0b10101010
    db 0b10100000
scr13_font__O:
    db 0b00000100
    db 0b10101010
    db 0b10101010
    db 0b01000000
scr13_font__P:
    db 0b00001100
    db 0b10101100
    db 0b10001000
    db 0b10000000
scr13_font__Q:
    db 0b00000100
    db 0b10101010
    db 0b10100100
    db 0b00100000
scr13_font__R:
    db 0b00001100
    db 0b10101010
    db 0b11001010
    db 0b10100000
scr13_font__S:
    db 0b00000110
    db 0b10000100
    db 0b00100010
    db 0b11000000
scr13_font__T:
    db 0b00001110
    db 0b01000100
    db 0b01000100
    db 0b01000000
scr13_font__U:
    db 0b00001010
    db 0b10101010
    db 0b10101010
    db 0b01100000
scr13_font__V:
    db 0b00001010
    db 0b10101010
    db 0b10100100
    db 0b01000000
scr13_font__W:
    db 0b00001010
    db 0b10101010
    db 0b10101110
    db 0b10100000
scr13_font__X:
    db 0b00001010
    db 0b10100100
    db 0b01001010
    db 0b10100000
scr13_font__Y:
    db 0b00001010
    db 0b10100100
    db 0b01000100
    db 0b01000000
scr13_font__Z:
    db 0b00001110
    db 0b00100100
    db 0b01001000
    db 0b11100000
scr13_font__block:
    db 0b00001110
    db 0b11101110
    db 0b11101110
    db 0b11100000
scr13_font__img_power1:     ; LENGTH: 8 CHARS
    db 0b00000000
    db 0b00000000
    db 0b00000001
    db 0b00010011
scr13_font__img_power2:
    db 0b00000000
    db 0b00010001
    db 0b11011101
    db 0b10010001
scr13_font__img_power3:
    db 0b00000000
    db 0b10001000
    db 0b10111011
    db 0b10011000
scr13_font__img_power4:
    db 0b00000000
    db 0b00000000
    db 0b00001000
    db 0b10001100
scr13_font__img_power5:
    db 0b00110011
    db 0b00110001
    db 0b00010000
    db 0b00000000
scr13_font__img_power6:
    db 0b00000000
    db 0b00001000
    db 0b11001111
    db 0b00110000
scr13_font__img_power7:
    db 0b00000000
    db 0b00000001
    db 0b00111111
    db 0b11000000
scr13_font__img_power8:
    db 0b11001100
    db 0b11001000
    db 0b10000000
    db 0b00000000