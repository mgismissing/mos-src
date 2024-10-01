VGA_CTRL_REGISTER equ 0x03D4
VGA_DATA_REGISTER equ 0x03D5
VGA_OFFSET_LOW    equ 0x000F
VGA_OFFSET_HIGH   equ 0x000E

pm_scr13_init:                                       ; pm_scr13_init() => None
    jmp $

pm_scr13_draw_checkerboard:                          ; pm_scr13_draw_checkerboard(ax > Start, bx > End, dl > Color) => None
    call pm_scr13_pixel_set
    add ax, 3
    cmp ax, bx
    jl pm_scr13_draw_checkerboard
    ret

pm_scr13_pixel_set:                                  ; pm_scr13_pixel_set(eax > Index, dl > Color) => None
    mov ecx, SCR13_ADDRESS_START
    add ecx, eax
    mov [ecx], dl
    ret
pm_scr13_pixel_set_if:                               ; pm_scr13_pixel_set_if(ax > Index, dl > Color, ef > Condition) => None
    jne .pm_scr13_pixel_set_if_false
    call pm_scr13_pixel_set
    .pm_scr13_pixel_set_if_false:
    ret
pm_scr13_pixel_set_if_x2:                            ; pm_scr13_pixel_set_if_x2(ax > Index, dl > Color, ef > Condition) => None
    jne .pm_scr13_pixel_set_if_false
    mov [pm_scr13_pixel_set_if_ax], ax
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    add ax, SCR13_WIDTH - 1
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    mov ax, [pm_scr13_pixel_set_if_ax]
    .pm_scr13_pixel_set_if_false:
    ret
pm_scr13_pixel_set_if_x4:                            ; pm_scr13_pixel_set_if_x4(ax > Index, dl > Color, ef > Condition) => None
    jne .pm_scr13_pixel_set_if_false
    mov [pm_scr13_pixel_set_if_ax], ax
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    add ax, SCR13_WIDTH - 3
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    add ax, SCR13_WIDTH - 3
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    add ax, SCR13_WIDTH - 3
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    inc ax
    call pm_scr13_pixel_set
    mov ax, [pm_scr13_pixel_set_if_ax]
    .pm_scr13_pixel_set_if_false:
    ret
pm_scr13_pixel_get:                                  ; pm_scr13_pixel_get(ax > Index) => dl > Color
    mov di, ax
    mov dl, [es:di]
    ret
pm_scr13_draw_line:                                  ; pm_scr13_draw_line(eax > Start, ebx > End, dl > Color) => None
    cmp eax, ebx
    je pm_scr13_global_ret
    call pm_scr13_pixel_set
    inc eax
    jmp pm_scr13_draw_line

pm_scr13_draw_vertical_line:                         ; pm_scr13_draw_vertical_line(ax > Start, bx > End, dl > Color) => None
    cmp ax, bx
    je pm_scr13_global_ret
    call pm_scr13_pixel_set
    add ax, SCR13_WIDTH
    jmp pm_scr13_draw_vertical_line
pm_scr13_draw_dotted_line:                           ; pm_scr13_draw_line(ax > Start, bx > End, dl > Color) => None
    cmp ax, bx
    jge pm_scr13_global_ret
    call pm_scr13_pixel_set
    add ax, 2
    jmp pm_scr13_draw_dotted_line

pm_scr13_draw_dotted_vertical_line:                  ; pm_scr13_draw_vertical_line(ax > Start, bx > End, dl > Color) => None
    cmp ax, bx
    jge pm_scr13_global_ret
    call pm_scr13_pixel_set
    add ax, SCR13_WIDTH * 2
    jmp pm_scr13_draw_dotted_vertical_line

pm_scr13_draw_rect:                                  ; pm_scr13_draw_rect(eax > Index, ebx > Width, ecx > Height, dl > Color) => None
    .start:
    mov dword [pm_scr13_draw_rect_width], ebx
    mov dword [pm_scr13_draw_rect_height], ecx
    mov ecx, 0x0000
    add ebx, eax
    .loop:
    cmp ecx, [pm_scr13_draw_rect_height]
    je pm_scr13_global_ret
    push ecx
    call pm_scr13_draw_line
    pop ecx
    add eax, SCR13_WIDTH
    sub eax, [pm_scr13_draw_rect_width]
    add ebx, SCR13_WIDTH
    inc ecx
    jmp .loop

pm_scr13_print_string:                               ; pm_scr13_print_string(eax > Index, ebx > String Pointer, dl > Color) => None
    mov si, bx             ; Copy string pointer into esi

    .next_char:
    ; Call the character printing function

    push ax
    lodsb                  ; Load the byte at [esi] into AL and increment esi
    cmp al, 0              ; Check if it's the null terminator
    je .finish    ; If yes, we're done

    ; The character is in AL, so move it into BX for the print_char function
    mov bx, 0x0000
    mov bl, al             ; Move character from al to bx
    pop ax
    ; Print the character
    call pm_scr13_print_char_partof_str
    jmp .next_char         ; Loop to the next character

    .finish:
    pop ax
    jmp pm_scr13_global_ret

pm_scr13_print_string_x4:                            ; pm_scr13_print_string_x4(ax > Index, bx > String Pointer, dl > Color) => None
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
    call pm_scr13_print_char_partof_str_x4
    jmp .next_char         ; Loop to the next character

    .finish:
    pop ax
    jmp pm_scr13_global_ret

pm_scr13_print_char_partof_str:                      ; pm_scr13_print_char_partof_str(ax > Index, dl > Color, bx > Char) => None
    mov [pm_scr13_print_char_partof_str_ax], ax
    mov [pm_scr13_print_char_partof_str_bx], bx
    mov [pm_scr13_print_char_partof_str_dl], dl
    call pm_scr13_print_char
    mov ax, [pm_scr13_print_char_partof_str_ax]
    mov bx, [pm_scr13_print_char_partof_str_bx]
    mov dl, [pm_scr13_print_char_partof_str_dl]
    add ax, 4
    ret
pm_scr13_print_char_partof_str_x2:                   ; pm_scr13_print_char_partof_str_x2(ax > Index, dl > Color, bx > Char) => None
    mov [pm_scr13_print_char_partof_str_ax], ax
    mov [pm_scr13_print_char_partof_str_bx], bx
    mov [pm_scr13_print_char_partof_str_dl], dl
    call pm_scr13_print_char_x2
    mov ax, [pm_scr13_print_char_partof_str_ax]
    mov bx, [pm_scr13_print_char_partof_str_bx]
    mov dl, [pm_scr13_print_char_partof_str_dl]
    add ax, 8
    ret
pm_scr13_print_char_partof_str_x4:                   ; pm_scr13_print_char_partof_str_x2(ax > Index, dl > Color, bx > Char) => None
    mov [pm_scr13_print_char_partof_str_ax], ax
    mov [pm_scr13_print_char_partof_str_bx], bx
    mov [pm_scr13_print_char_partof_str_dl], dl
    call pm_scr13_print_char_x4
    mov ax, [pm_scr13_print_char_partof_str_ax]
    mov bx, [pm_scr13_print_char_partof_str_bx]
    mov dl, [pm_scr13_print_char_partof_str_dl]
    add ax, 16
    ret

pm_scr13_print_char:                                 ; pm_scr13_print_char(ax > Index, dl > Color, bx > Char) => None
    mov byte [pm_scr13_print_char_color], dl
    sub bx, ' ' ; FIRST CHARACTER IN FONT
    mov cx, ax
    mov ax, 0x0004
    mul bx
    mov bx, ax
    mov ax, cx
    add bx, scr13_font_start
    mov byte [pm_scr13_print_char_current_pixel_mask], 0b10000000
    mov byte [pm_scr13_print_char_current_pixel], 0x00
    .pm_scr13_print_char_loop1:
        mov cx, [bx]
        and cx, [pm_scr13_print_char_current_pixel_mask]
        cmp cx, [pm_scr13_print_char_current_pixel_mask]
        mov dl, [pm_scr13_print_char_color]
        call pm_scr13_pixel_set_if
        shr byte [pm_scr13_print_char_current_pixel_mask], 1
        inc ax

        mov cx, [pm_scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000011
        je .pm_scr13_print_char_newline

        mov cx, [pm_scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000111
        je .pm_scr13_print_char_nextbyte
    .pm_scr13_print_char_loop2:
        inc byte [pm_scr13_print_char_current_pixel]
        cmp byte [pm_scr13_print_char_current_pixel], 32
        jne .pm_scr13_print_char_loop1
        ret
    
    .pm_scr13_print_char_newline:
        add ax, SCR13_WIDTH - 4
        jmp .pm_scr13_print_char_loop2

    .pm_scr13_print_char_nextbyte:
        add ax, SCR13_WIDTH - 4
        inc bx
        mov byte [pm_scr13_print_char_current_pixel_mask], 0b10000000
        jmp .pm_scr13_print_char_loop2

pm_scr13_print_char_x2:                              ; pm_scr13_print_char_x2(ax > Index, dl > Color, bx > Char) => None
    mov byte [pm_scr13_print_char_color], dl
    sub bx, ' ' ; FIRST CHARACTER IN FONT
    mov cx, ax
    mov ax, 0x0004
    mul bx
    mov bx, ax
    mov ax, cx
    add bx, scr13_font_start
    mov byte [pm_scr13_print_char_current_pixel_mask], 0b10000000
    mov byte [pm_scr13_print_char_current_pixel], 0x00
    .pm_scr13_print_char_x2_loop1:
        mov cx, [bx]
        and cx, [pm_scr13_print_char_current_pixel_mask]
        cmp cx, [pm_scr13_print_char_current_pixel_mask]
        mov dl, [pm_scr13_print_char_color]
        call pm_scr13_pixel_set_if_x2
        shr byte [pm_scr13_print_char_current_pixel_mask], 1
        add ax, 2

        mov cx, [pm_scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000011
        je .pm_scr13_print_char_x2_newline

        mov cx, [pm_scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000111
        je .pm_scr13_print_char_x2_nextbyte
    .pm_scr13_print_char_x2_loop2:
        inc byte [pm_scr13_print_char_current_pixel]
        cmp byte [pm_scr13_print_char_current_pixel], 32
        jne .pm_scr13_print_char_x2_loop1
        ret
    
    .pm_scr13_print_char_x2_newline:
        add ax, SCR13_WIDTH * 2 - 8
        jmp .pm_scr13_print_char_x2_loop2

    .pm_scr13_print_char_x2_nextbyte:
        add ax, SCR13_WIDTH * 2 - 8
        inc bx
        mov byte [pm_scr13_print_char_current_pixel_mask], 0b10000000
        jmp .pm_scr13_print_char_x2_loop2
    
pm_scr13_draw_img_8x8_line:                          ; pm_scr13_draw_img_8x8_line(ax > Start Index, bx > Image Pointer, cx > End Index) => None
    mov [.var_end], cx
    mov [.var_bx], bx
    .loop:
    mov [.var_ax], ax
    cmp ax, [.var_end]
    jge pm_scr13_global_ret
    mov bx, [.var_bx]
    call pm_scr13_draw_img_8x8
    mov ax, [.var_ax]
    add ax, 8
    jmp .loop
    .var_end: dw 0x0000
    .var_ax: dw 0x0000
    .var_bx: dw 0x0000

pm_scr13_draw_img_32x32:                             ; pm_scr13_draw_img_32x32(ax > Index, bx > Image Pointer) => None # 0xFF is TRANSPARENT
    mov dx, 0
    mov cx, 0
    .loop:
    mov dl, [bx]
    cmp dl, 0xFF
    je .dontdraw
    push ecx
    call pm_scr13_pixel_set
    pop ecx
    .dontdraw:
    inc ax
    inc bx
    inc cx
    cmp cx, 0x0400
    je pm_scr13_global_ret
    mov dh, cl
    and dh, 0b00011111
    cmp dh, 0b00000000
    je .newline
    jmp .loop

    .newline:
    add ax, SCR13_WIDTH - 32
    jmp .loop

pm_scr13_draw_img_16x16:                             ; pm_scr13_draw_img_16x16(eax > Index, ebx > Image Pointer) => None # 0xFF is TRANSPARENT
    mov edx, 0
    mov ecx, 0
    .loop:
    mov dl, [ebx]
    cmp dl, 0xFF
    je .dontdraw
    push ecx
    call pm_scr13_pixel_set
    pop ecx
    .dontdraw:
    inc eax
    inc ebx
    inc ecx
    cmp ecx, 0x00000100
    je pm_scr13_global_ret
    mov dh, cl
    and dh, 0b00001111
    cmp dh, 0b00000000
    je .newline
    jmp .loop

    .newline:
    add eax, SCR13_WIDTH - 16
    jmp .loop

pm_scr13_draw_img_8x8:                               ; pm_scr13_draw_img_8x8(ax > Index, bx > Image Pointer) => None # 0xFF is TRANSPARENT
    mov dx, 0
    mov cx, 0
    .loop:
    mov dl, [bx]
    cmp dl, 0xFF
    je .dontdraw
    push ecx
    call pm_scr13_pixel_set
    pop ecx
    .dontdraw:
    inc ax
    inc bx
    inc cx
    cmp cx, 0x0040
    je pm_scr13_global_ret
    mov dh, cl
    and dh, 0b00000111
    cmp dh, 0b00000000
    je .newline
    jmp .loop

    .newline:
    add ax, SCR13_WIDTH - 8
    jmp .loop

pm_scr13_print_char_x4:                              ; pm_scr13_print_char_x4(ax > Index, dl > Color, bx > Char) => None
    mov byte [pm_scr13_print_char_color], dl
    sub bx, ' ' ; FIRST CHARACTER IN FONT
    mov cx, ax
    mov ax, 0x0004
    mul bx
    mov bx, ax
    mov ax, cx
    add bx, scr13_font_start
    mov byte [pm_scr13_print_char_current_pixel_mask], 0b10000000
    mov byte [pm_scr13_print_char_current_pixel], 0x00
    .pm_scr13_print_char_x4_loop1:
        mov cx, [bx]
        and cx, [pm_scr13_print_char_current_pixel_mask]
        cmp cx, [pm_scr13_print_char_current_pixel_mask]
        mov dl, [pm_scr13_print_char_color]
        call pm_scr13_pixel_set_if_x4
        shr byte [pm_scr13_print_char_current_pixel_mask], 1
        add ax, 4

        mov cx, [pm_scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000011
        je .pm_scr13_print_char_x4_newline

        mov cx, [pm_scr13_print_char_current_pixel]
        and cx, 0b00000111
        cmp cx, 0b00000111
        je .pm_scr13_print_char_x4_nextbyte
    .pm_scr13_print_char_x4_loop2:
        inc byte [pm_scr13_print_char_current_pixel]
        cmp byte [pm_scr13_print_char_current_pixel], 32
        jne .pm_scr13_print_char_x4_loop1
        ret
    
    .pm_scr13_print_char_x4_newline:
        add ax, SCR13_WIDTH * 4 - 16
        jmp .pm_scr13_print_char_x4_loop2

    .pm_scr13_print_char_x4_nextbyte:
        add ax, SCR13_WIDTH * 4 - 16
        inc bx
        mov byte [pm_scr13_print_char_current_pixel_mask], 0b10000000
        jmp .pm_scr13_print_char_x4_loop2

pm_scr13_global_ret: ret

pm_scr13_draw_rect_width: dd 0x00000000
pm_scr13_draw_rect_height: dd 0x00000000

pm_scr13_print_char_partof_str_ax: dw 0x0000
pm_scr13_print_char_partof_str_bx: dw 0x0000
pm_scr13_print_char_partof_str_dl: db 0x00
pm_scr13_print_char_current_pixel_mask: dw 0x0000
pm_scr13_print_char_current_pixel: dw 0x0000
pm_scr13_print_char_color: db 0x00
pm_scr13_pixel_set_if_ax: dw 0x0000