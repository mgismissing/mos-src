scr13_init:                                       ; scr13_init() => None
    mov ax, 0x0013
    int 0x10
    mov ax, 0xA000
    mov es, ax
    mov ax, 0x0000
    ret

scr13_draw_checkerboard:                          ; scr13_draw_checkerboard(ax > Start, bx > End, dl > Color) => None
    call scr13_pixel_set
    add ax, 3
    cmp ax, bx
    jl scr13_draw_checkerboard
    ret

scr13_pixel_set:                                  ; scr13_pixel_set(ax > Index, dl > Color) => None
    mov di, ax
    mov [es:di], dl
    ret
scr13_pixel_set_if:                               ; scr13_pixel_set_if(ax > Index, dl > Color, ef > Condition) => None
    jne .scr13_pixel_set_if_false
    call scr13_pixel_set
    .scr13_pixel_set_if_false:
    ret
scr13_pixel_set_if_x2:                            ; scr13_pixel_set_if_x2(ax > Index, dl > Color, ef > Condition) => None
    jne .scr13_pixel_set_if_false
    mov [scr13_pixel_set_if_ax], ax
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    add ax, SCR13_WIDTH - 1
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    mov ax, [scr13_pixel_set_if_ax]
    .scr13_pixel_set_if_false:
    ret
scr13_pixel_set_if_x4:                            ; scr13_pixel_set_if_x4(ax > Index, dl > Color, ef > Condition) => None
    jne .scr13_pixel_set_if_false
    mov [scr13_pixel_set_if_ax], ax
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    add ax, SCR13_WIDTH - 3
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    add ax, SCR13_WIDTH - 3
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    add ax, SCR13_WIDTH - 3
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    inc ax
    call scr13_pixel_set
    mov ax, [scr13_pixel_set_if_ax]
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

scr13_draw_vertical_line:                         ; scr13_draw_vertical_line(ax > Start, bx > End, dl > Color) => None
    cmp ax, bx
    je scr13_global_ret
    call scr13_pixel_set
    add ax, SCR13_WIDTH
    jmp scr13_draw_vertical_line

scr13_draw_rect:                                  ; scr13_draw_rect(ax > Index, bx > Width, cx > Height, dl > Color) => None
    .start:
    mov word [scr13_draw_rect_width], bx
    mov word [scr13_draw_rect_height], cx
    mov cx, 0x0000
    add bx, ax
    .loop:
    cmp cx, [scr13_draw_rect_height]
    je scr13_global_ret
    call scr13_draw_line
    add ax, SCR13_WIDTH
    sub ax, [scr13_draw_rect_width]
    add bx, SCR13_WIDTH
    ;sub bx, [scr13_draw_rect_width]
    inc cx
    jmp .loop

scr13_print_string:
    mov si, bx             ; Copy string pointer into si

    .next_char:
    ; Call the character printing function

    push ax
    lodsb                  ; Load the byte at [si] into AL and increment si
    cmp al, 0              ; Check if it's the null terminator
    je .finish    ; If yes, we're done

    ; The character is in AL, so move it into BX for the print_char function
    mov bx, 0x0000
    mov bl, al             ; Move character from al to bx
    pop ax
    ; Print the character
    call scr13_print_char_partof_str
    jmp .next_char         ; Loop to the next character

    .finish:
    pop ax
    jmp scr13_global_ret

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
scr13_print_char_partof_str_x2:                   ; scr13_print_char_partof_str_x2(ax > Index, dl > Color, bx > Char) => None
    mov [scr13_print_char_partof_str_ax], ax
    mov [scr13_print_char_partof_str_bx], bx
    mov [scr13_print_char_partof_str_dl], dl
    call scr13_print_char_x2
    mov ax, [scr13_print_char_partof_str_ax]
    mov bx, [scr13_print_char_partof_str_bx]
    mov dl, [scr13_print_char_partof_str_dl]
    add ax, 8
    ret
scr13_print_char_partof_str_x4:                   ; scr13_print_char_partof_str_x2(ax > Index, dl > Color, bx > Char) => None
    mov [scr13_print_char_partof_str_ax], ax
    mov [scr13_print_char_partof_str_bx], bx
    mov [scr13_print_char_partof_str_dl], dl
    call scr13_print_char_x4
    mov ax, [scr13_print_char_partof_str_ax]
    mov bx, [scr13_print_char_partof_str_bx]
    mov dl, [scr13_print_char_partof_str_dl]
    add ax, 16
    ret

scr13_print_char:                                 ; scr13_print_char(ax > Index, dl > Color, bx > Char) => None
    mov byte [scr13_print_char_color], dl
    sub bx, ' ' ; FIRST CHARACTER IN FONT
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

scr13_print_char_x2:                              ; scr13_print_char_x2(ax > Index, dl > Color, bx > Char) => None
    mov byte [scr13_print_char_color], dl
    sub bx, ' ' ; FIRST CHARACTER IN FONT
    mov cx, ax
    mov ax, 0x0004
    mul bx
    mov bx, ax
    mov ax, cx
    add bx, scr13_font_start
    mov byte [scr13_print_char_current_pixel_mask], 0b10000000
    mov byte [scr13_print_char_current_pixel], 0x00
    .scr13_print_char_x2_loop1:
        mov cx, [bx]
        and cx, [scr13_print_char_current_pixel_mask]
        cmp cx, [scr13_print_char_current_pixel_mask]
        mov dl, [scr13_print_char_color]
        call scr13_pixel_set_if_x2
        shr byte [scr13_print_char_current_pixel_mask], 1
        add ax, 2

        mov cx, [scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000011
        je .scr13_print_char_x2_newline

        mov cx, [scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000111
        je .scr13_print_char_x2_nextbyte
    .scr13_print_char_x2_loop2:
        inc byte [scr13_print_char_current_pixel]
        cmp byte [scr13_print_char_current_pixel], 32
        jne .scr13_print_char_x2_loop1
        ret
    
    .scr13_print_char_x2_newline:
        add ax, SCR13_WIDTH * 2 - 8
        jmp .scr13_print_char_x2_loop2

    .scr13_print_char_x2_nextbyte:
        add ax, SCR13_WIDTH * 2 - 8
        inc bx
        mov byte [scr13_print_char_current_pixel_mask], 0b10000000
        jmp .scr13_print_char_x2_loop2
    
scr13_draw_img_8x8_line:                          ; scr13_draw_img_8x8_line(ax > Start Index, bx > Image Pointer, cx > End Index) => None
    mov [.var_end], cx
    mov [.var_bx], bx
    .loop:
    mov [.var_ax], ax
    cmp ax, [.var_end]
    jge scr13_global_ret
    mov bx, [.var_bx]
    call scr13_draw_img_8x8
    mov ax, [.var_ax]
    add ax, 8
    jmp .loop
    .var_end: dw 0x0000
    .var_ax: dw 0x0000
    .var_bx: dw 0x0000

scr13_draw_img_32x32:                             ; scr13_draw_img_32x32(ax > Index, bx > Image Pointer) => None # 0xFF is TRANSPARENT
    mov dx, 0
    mov cx, 0
    .loop:
    mov dl, [bx]
    cmp dl, 0xFF
    je .dontdraw
    call scr13_pixel_set
    .dontdraw:
    inc ax
    inc bx
    inc cx
    cmp cx, 0x0400
    je scr13_global_ret
    mov dh, cl
    and dh, 0b00011111
    cmp dh, 0b00000000
    je .newline
    jmp .loop

    .newline:
    add ax, SCR13_WIDTH - 32
    jmp .loop

scr13_draw_img_16x16:                             ; scr13_draw_img_16x16(ax > Index, bx > Image Pointer) => None # 0xFF is TRANSPARENT
    mov dx, 0
    mov cx, 0
    .loop:
    mov dl, [bx]
    cmp dl, 0xFF
    je .dontdraw
    call scr13_pixel_set
    .dontdraw:
    inc ax
    inc bx
    inc cx
    cmp cx, 0x0100
    je scr13_global_ret
    mov dh, cl
    and dh, 0b00001111
    cmp dh, 0b00000000
    je .newline
    jmp .loop

    .newline:
    add ax, SCR13_WIDTH - 16
    jmp .loop

scr13_draw_img_8x8:                               ; scr13_draw_img_8x8(ax > Index, bx > Image Pointer) => None # 0xFF is TRANSPARENT
    mov dx, 0
    mov cx, 0
    .loop:
    mov dl, [bx]
    cmp dl, 0xFF
    je .dontdraw
    call scr13_pixel_set
    .dontdraw:
    inc ax
    inc bx
    inc cx
    cmp cx, 0x0040
    je scr13_global_ret
    mov dh, cl
    and dh, 0b00000111
    cmp dh, 0b00000000
    je .newline
    jmp .loop

    .newline:
    add ax, SCR13_WIDTH - 8
    jmp .loop

scr13_print_char_x4:                              ; scr13_print_char_x4(ax > Index, dl > Color, bx > Char) => None
    mov byte [scr13_print_char_color], dl
    sub bx, ' ' ; FIRST CHARACTER IN FONT
    mov cx, ax
    mov ax, 0x0004
    mul bx
    mov bx, ax
    mov ax, cx
    add bx, scr13_font_start
    mov byte [scr13_print_char_current_pixel_mask], 0b10000000
    mov byte [scr13_print_char_current_pixel], 0x00
    .scr13_print_char_x4_loop1:
        mov cx, [bx]
        and cx, [scr13_print_char_current_pixel_mask]
        cmp cx, [scr13_print_char_current_pixel_mask]
        mov dl, [scr13_print_char_color]
        call scr13_pixel_set_if_x4
        shr byte [scr13_print_char_current_pixel_mask], 1
        add ax, 4

        mov cx, [scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000011
        je .scr13_print_char_x4_newline

        mov cx, [scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000111
        je .scr13_print_char_x4_nextbyte
    .scr13_print_char_x4_loop2:
        inc byte [scr13_print_char_current_pixel]
        cmp byte [scr13_print_char_current_pixel], 32
        jne .scr13_print_char_x4_loop1
        ret
    
    .scr13_print_char_x4_newline:
        add ax, SCR13_WIDTH * 4 - 16
        jmp .scr13_print_char_x4_loop2

    .scr13_print_char_x4_nextbyte:
        add ax, SCR13_WIDTH * 4 - 16
        inc bx
        mov byte [scr13_print_char_current_pixel_mask], 0b10000000
        jmp .scr13_print_char_x4_loop2

scr13_global_ret: ret

scr13_draw_rect_width: dw 0x0000
scr13_draw_rect_height: dw 0x0000

scr13_print_char_partof_str_ax: dw 0x0000
scr13_print_char_partof_str_bx: dw 0x0000
scr13_print_char_partof_str_dl: db 0x00
scr13_print_char_current_pixel_mask: dw 0x0000
scr13_print_char_current_pixel: dw 0x0000
scr13_print_char_color: db 0x00
scr13_pixel_set_if_ax: dw 0x0000

scr13_font_start:
scr13_font__space:
    db 0b00000000
    db 0b00000000
    db 0b00000000
    db 0b00000000
times ('.' - ' ' - 1) * 4 db 0
scr13_font__dot:
    db 0b00000000
    db 0b00000000
    db 0b00000000
    db 0b01000000
times ('A' - '.' - 1) * 4 db 0
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