scr_init:                                       ; scr_init() => None
    mov ax, 0x0003
    int 0x10
    mov ax, 0xB800
    mov es, ax
    mov ax, 0x0000
    ret

scr_clear:                                      ; scr_clear(dl > Background Color) => None
    mov ax, 0x0003
    int 0x10
    mov ax, 0x0000
    mov bx, SCR_SIZE
    call scr_draw_line
    ret

scr_cursor_disable:                             ; scr_cursor_disable() => None
    mov ax, 0x0000
    mov ah, 0x01
    mov ch, 0x3F
    int 0x10
    ret

scr_cursor_enable:                              ; scr_cursor_enable(cx > Cursor Type) => None
    mov ax, 0x0000
    mov ah, 0x01
    int 0x10
    ret

scr_cursor_print_hex:                           ; scr_cursor_print_hex(al > Value, bl > Color) => None
    mov   ah, al            ; make al and ah equal so we can isolate each half of the byte
    shr   ah, 4             ; ch now has the high nibble
    and   al, 0x0F          ; cl now has the low nibble

    push ax
    push bx
    mov bx, 0
    mov bl, ah              ; get the value in the higher nybble
    add bx, .chars          ; offset the table by the characters table pointer
    mov al, [bx]            ; get the corresponding character
    pop bx
    mov cx, 0x0001
    call scr_cursor_print_char
    pop ax

    push ax
    push bx
    mov bx, 0
    mov bl, al              ; get the value in the lower nybble
    add bx, .chars          ; offset the table by the characters table pointer
    mov al, [bx]            ; get the corresponding character
    pop bx
    mov cx, 0x0001
    call scr_cursor_print_char
    pop ax
    ret

    .chars: db '0123456789ABCDEF'

scr_vga_disable_blinking:                       ; scr_vga_disable_blinking() => None
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

scr_vga_enable_blinking:                        ; scr_vga_enable_blinking() => None
    mov dx, 0x03DA                              ; reset the flip-flop
    in al, dx

    mov dx, 0x03C0                              ; index 0x10  (20h + 10h)?
    mov al, 0x30
    out dx, al

    inc dx                                      ; set bit 3 to enable blink
    in al, dx
    or al, 0b00001000
    dec dx
    out dx, al
    ret

scr_cursor_set_pos:                             ; scr_cursor_set_pos(dl > X Position, dh > Y Position) => None
    mov ax, 0x0200
    int 0x10
    ret

scr_cursor_get_pos:                            ; scr_cursor_get_pos() => ch: Scanline Start, cl: Scanline End, dh > Y Position, dl > X Position
    mov ax, 0x0300
    int 0x10
    ret

scr_cursor_get_char:                           ; scr_cursor_get_char(bh > Page Number) => ah > Color, al > Char
    mov ax, 0x0800
    int 0x10
    ret

scr_cursor_get_char_at:                        ; scr_cursor_get_char_at(dl > X Position, dh > Y Position, bh > Page Number) => ah > Color, al > Char
    call scr_cursor_set_pos
    call scr_cursor_get_char
    ret

scr_cursor_print_char:                         ; scr_cursor_print_char(al > Char, bh > Page Number, bl > Color, cx > Times to print) => None
    mov ah, 0x09
    int 0x10
    mov ah, 0x0E
    int 0x10
    ret

scr_cursor_print_char_special:                 ; scr_cursor_print_char_special(al > Char, bh > Page Number, cx > Times to print) => None
    mov ah, 0x0E
    int 0x10
    ret

scr_cursor_print_string:                       ; scr_cursor_print_string(si > String Pointer, bh > Page Number, bl > Color) => None
    lodsb
    cmp al, 0
    je scr_global_ret
    mov cx, 1
    call scr_cursor_print_char
    jmp scr_cursor_print_string

scr_cursor_print_string_special:               ; scr_cursor_print_string_special(si > String Pointer, bh > Page Number) => None
    lodsb
    cmp al, 0
    je scr_global_ret
    mov cx, 1
    call scr_cursor_print_char_special
    jmp scr_cursor_print_string_special

scr_char_set:                                   ; scr_char_set(ax > Index, dl > Color, dh > Char) => None
    mov di, ax
    mov [es:di], dh
    inc di
    mov [es:di], dl
    ret
scr_char_set_color:                             ; scr_char_set_color(ax > Index, dl > Color) => None
    mov di, ax
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

scr_str_crlf: db 0x0D, 0x0A, 0x00