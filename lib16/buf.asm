scr_print_char:                                 ; scr_print_char(ax > Index, bl > Char, dl > Color) => None
    mov [scr_font_temp_ax], ax                  ; ax has important information in it so we temporarily store its value somewhere else
    mov [scr_font_color], dl                    ; save the color for later (dx will be used for other things)
    sub bx, 'A'
    mov ax, 0x0004                              ; SOL has to be multiplied by 4 because one letter's image content is 4 bytes long
    mul bx                                      ; SOL * 4
    mov bx, ax                                  ; put SOL back from ax to bx again because multiplication forcefully does AX * XX
    mov ax, [scr_font_temp_ax]                  ; restore the original contents of ax
    add bx, scr_font_start                      ; offset bx by the start of the font section
    .scr_print_char_loop:                       ; loop for printing a pixel at a time
        mov dx, [bx]                            ; set the currentByte to the first byte of the image
        and dx, 0b10000000                      ; get only the last bit of currentByte with a mask
        cmp dx, 0b10000000                      ; check if the last bit of currentByte is a 1
        mov dl, [scr_font_color]
        call scr_pixel_set_if                   ; if it is, set the pixel to a certain color, if it isn't, leave the pixel as it is

        inc ax                                  ; keep doing this
        mov dx, [bx]
        and dx, 0b01000000
        cmp dx, 0b01000000
        mov dl, [scr_font_color]
        call scr_pixel_set_if

        inc ax
        mov dx, [bx]
        and dx, 0b00100000
        cmp dx, 0b00100000
        mov dl, [scr_font_color]
        call scr_pixel_set_if

        inc ax
        mov dx, [bx]
        and dx, 0b00010000
        cmp dx, 0b00010000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
        
        inc ax
        mov dx, [bx]
        and dx, 0b00001000
        cmp dx, 0b00001000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
        
        inc ax
        mov dx, [bx]
        and dx, 0b00000100
        cmp dx, 0b00000100
        mov dl, [scr_font_color]
        call scr_pixel_set_if
        



        add ax, SCR_WIDTH - 5
        mov dx, [bx]
        and dx, 0b00000010
        cmp dx, 0b00000010
        mov dl, [scr_font_color]
        call scr_pixel_set_if
        
        inc ax
        mov dx, [bx]
        and dx, 0b00000001
        cmp dx, 0b00000001
        mov dl, [scr_font_color]
        call scr_pixel_set_if

        inc bx
        inc ax
        mov dx, [bx]
        and dx, 0b10000000
        cmp dx, 0b10000000
        mov dl, [scr_font_color]
        call scr_pixel_set_if

        inc ax
        mov dx, [bx]
        and dx, 0b01000000
        cmp dx, 0b01000000
        mov dl, [scr_font_color]
        call scr_pixel_set_if

        inc ax
        mov dx, [bx]
        and dx, 0b00100000
        cmp dx, 0b00100000
        mov dl, [scr_font_color]
        call scr_pixel_set_if

        inc ax
        mov dx, [bx]
        and dx, 0b00010000
        cmp dx, 0b00010000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
        


        add ax, SCR_WIDTH - 5
        mov dx, [bx]
        and dx, 0b00001000
        cmp dx, 0b00001000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
        
        inc ax
        mov dx, [bx]
        and dx, 0b00000100
        cmp dx, 0b00000100
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00000010
        cmp dx, 0b00000010
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00000001
        cmp dx, 0b00000001
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc bx
        inc ax
        mov dx, [bx]
        and dx, 0b10000000
        cmp dx, 0b10000000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b01000000
        cmp dx, 0b01000000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                


        add ax, SCR_WIDTH - 5
        mov dx, [bx]
        and dx, 0b00100000
        cmp dx, 0b00100000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00010000
        cmp dx, 0b00010000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00001000
        cmp dx, 0b00001000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00000100
        cmp dx, 0b00000100
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00000010
        cmp dx, 0b00000010
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00000001
        cmp dx, 0b00000001
        mov dl, [scr_font_color]
        call scr_pixel_set_if
        

        inc bx
        add ax, SCR_WIDTH - 5
        mov dx, [bx]
        and dx, 0b10000000
        cmp dx, 0b10000000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b01000000
        cmp dx, 0b01000000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00100000
        cmp dx, 0b00100000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00010000
        cmp dx, 0b00010000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00001000
        cmp dx, 0b00001000
        mov dl, [scr_font_color]
        call scr_pixel_set_if
                
        inc ax
        mov dx, [bx]
        and dx, 0b00000100
        cmp dx, 0b00000100
        mov dl, [scr_font_color]
        call scr_pixel_set_if

    .scr_print_char_end:
        mov ax, [scr_font_temp_ax]                  ; restore the original contents of ax
        add ax, 6
        ret