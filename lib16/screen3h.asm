scr_init:                                       ; scr_init() => None
    mov ax, 0x0003
    int 0x10
    mov ax, 0xB800
    mov es, ax
    mov ax, 0x0000
    ret

scr_cursor_disable:                             ; scr_cursor_disable() => None
    cmp byte [boot_safe_mode_status], 0x01
    je scr_global_ret
    mov ax, 0x0000
    mov ah, 0x01
    mov ch, 0x3F
    int 0x10
    ret

scr_vga_disable_blinking:                       ; scr_vga_disable_blinking() => None
    cmp byte [boot_safe_mode_status], 0x01
    je scr_global_ret
    mov dx, 0x03DA                              ; reset the flip-flop
    in al, dx

    mov dx, 0x03C0                              ; index 0x10  (20h + 10h)?
    mov al, 0x30
    out dx, al

    inc dx                                      ; clear bit 3 to disable blink
    in al, dx
    and al, 0b11110111
    dec dx
    out dx, al
    ret

scr_cursor_set_pos:                             ; scr_cursor_set_pos(dl > X Position, dh > Y Position) => None
    mov ax, 0
    mov bx, 0
    mov ah, 2
    mov bh, 0
    int 10h
    ret

scr_char_set:                                   ; scr_char_set(ax > Index, dl > Color, dh > Char) => None
    mov di, ax
    mov [es:di], dh
    inc di
    mov [es:di], dl
    ret
scr_char_set_if:                                ; scr_char_set_if(ax > Index, dl > Color, ef > Condition) => None
    jne .scr_char_set_if_false
    call scr_char_set
    .scr_char_set_if_false:
    ret
scr_char_set_auto:                              ; scr_char_set_auto(ax > Index, dl > Color, dh > Char) => None
    call scr_char_set
    add ax, 2
    ret
scr_print_string:                               ; scr_print_string(ax > Index, dl > Color, bx > String Pointer) => None
    mov dh, [bx]
    cmp dh, 0
    je scr_global_ret
    call scr_char_set
    add ax, 2
    inc bx
    jmp scr_print_string
scr_char_get:                                   ; scr_char_get(ax > Index) => dl > Color, dh > Char
    mov di, ax
    mov dh, [es:di]
    inc di
    mov dl, [es:di]
    ret
scr_draw_line:                                  ; scr_draw_line(ax > Start, bx > End, dl > Color, dh > Char) => None
    cmp ax, bx
    je scr_global_ret
    call scr_char_set
    add ax, 2
    jmp scr_draw_line

scr_global_ret:
    ret