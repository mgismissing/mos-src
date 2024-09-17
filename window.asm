win_start:
    call scr13_init
    jmp win_main

win_main:
    .start:
    mov word [winvar_mouse_pos], 160 + (SCR13_WIDTH * 100)
    .loop:
        call win_draw_background
        call win_draw_window
        mov ax, [winvar_mouse_pos]
        call win_draw_cursor
        call kb_waitForKey
        cmp ah, 0x48    ; UP
        je .pointer_up
        cmp ah, 0x50    ; DOWN
        je .pointer_down
        cmp ah, 0x4B    ; LEFT
        je .pointer_left
        cmp ah, 0x4D    ; RIGHT
        je .pointer_right
        jmp .loop
    
    .pointer_up:
        sub word [winvar_mouse_pos], SCR13_WIDTH * 8
        jmp .loop
    .pointer_down:
        add word [winvar_mouse_pos], SCR13_WIDTH * 8
        jmp .loop
    .pointer_left:
        sub word [winvar_mouse_pos], 8
        jmp .loop
    .pointer_right:
        add word [winvar_mouse_pos], 8
        jmp .loop

    jmp win_end

win_draw_background:
    ; BACKGROUND
    mov ax, 0x0000
    mov bx, SCR13_SIZE
    mov dl, 0x7C
    call scr13_draw_line
    ret

win_draw_window:
    ; WINDOW - BASE SHAPE
    mov ax, 60 + (SCR13_WIDTH * 20)
    mov bx, 200
    mov cx, 160
    mov dl, 0x1B
    call scr13_draw_rect

    ; WINDOW - TOP BRIGHTER LINE
    mov ax, 60 + (SCR13_WIDTH * 20)
    mov bx, (260 - 1) + (SCR13_WIDTH * 20)
    mov dl, 0x1D
    call scr13_draw_line

    mov ax, 60 + (SCR13_WIDTH * 20)
    mov bx, 60 + (SCR13_WIDTH * (180 - 1))
    mov dl, 0x1D
    call scr13_draw_vertical_line

    ; WINDOW - TOP WHITE LINE
    mov ax, (60 + 1) + (SCR13_WIDTH * (20 + 1))
    mov bx, (260 - 2) + (SCR13_WIDTH * (20 + 1))
    mov dl, 0x1F
    call scr13_draw_line

    mov ax, (60 + 1) + (SCR13_WIDTH * (20 + 1))
    mov bx, (60 + 1) + (SCR13_WIDTH * (180 - 2))
    mov dl, 0x1F
    call scr13_draw_vertical_line

    ; WINDOW - BOTTOM BLACK LINE
    mov ax, 60 + (SCR13_WIDTH * (180 - 1))
    mov bx, 260 + (SCR13_WIDTH * (180 - 1))
    mov dl, 0x11
    call scr13_draw_line

    mov ax, (260 - 1) + (SCR13_WIDTH * 20)
    mov bx, (260 - 1) + (SCR13_WIDTH * 180)
    mov dl, 0x11
    call scr13_draw_vertical_line

    ; WINDOW - BOTTOM DARK GRAY LINE
    mov ax, (60 + 1) + (SCR13_WIDTH * (180 - 2))
    mov bx, (260 - 1) + (SCR13_WIDTH * (180 - 2))
    mov dl, 0x17
    call scr13_draw_line

    mov ax, (260 - 2) + (SCR13_WIDTH * (20 + 1))
    mov bx, (260 - 2) + (SCR13_WIDTH * (180 - 1))
    mov dl, 0x17
    call scr13_draw_vertical_line

    ; WINDOW TITLE BAR
    mov ax, (60 + 3) + (SCR13_WIDTH * (20 + 3))
    mov bx, (200 - 6)
    mov cx, 10
    mov dl, 0x01
    call scr13_draw_rect

    ; WINDOW TITLE
    mov ax, (60 + 5) + (SCR13_WIDTH * (20 + 4))
    mov bx, winstr_test_window
    mov dl, 0x1F
    call scr13_print_string

    ; WINDOW CLOSE BUTTON
    mov ax, (260 - 12) + (SCR13_WIDTH * (20 + 4))
    mov bx, winico_button_close
    call scr13_draw_img_8x8

    ; WINDOW TEXT
    mov ax, (60 + 5) + (SCR13_WIDTH * (20 + 15))
    mov bx, winstr_test_window_desc
    mov dl, 0x12
    call scr13_print_string

    ; RETURN
    ret

win_draw_cursor:
    mov bx, winico_pointer_normal
    call scr13_draw_img_8x8
    ret



win_end:
    jmp $

winvar_mouse_pos: dw 0x0000

winstr_test_string: db 'TEST STRING', 0
winstr_test_window: db 'TEST WINDOW', 0
winstr_test_window_desc: db 'THIS WINDOW IS A TEST.', 0

winico_pointer_normal:
    db 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    db 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    db 0x00, 0x0F, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    db 0x00, 0x0F, 0x0F, 0x00, 0xFF, 0xFF, 0xFF, 0xFF
    db 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0xFF, 0xFF, 0xFF
    db 0x00, 0x0F, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF
    db 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF

winico_button_close:
    db 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C
    db 0x0C, 0x0F, 0x0C, 0x0C, 0x0C, 0x0C, 0x0F, 0x0C
    db 0x0C, 0x0C, 0x0F, 0x0C, 0x0C, 0x0F, 0x0C, 0x0C
    db 0x0C, 0x0C, 0x0C, 0x0F, 0x0F, 0x0C, 0x0C, 0x0C
    db 0x0C, 0x0C, 0x0C, 0x0F, 0x0F, 0x0C, 0x0C, 0x0C
    db 0x0C, 0x0C, 0x0F, 0x0C, 0x0C, 0x0F, 0x0C, 0x0C
    db 0x0C, 0x0F, 0x0C, 0x0C, 0x0C, 0x0C, 0x0F, 0x0C
    db 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C