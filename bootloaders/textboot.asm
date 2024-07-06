bits 16
[org 0x7C00]

SCR_ADDRESS_START   equ  0xB800
SCR_WIDTH           equ  0xA0
SCR_HEIGHT          equ  0x32
SCR_ADDRESS_END     equ  0xD740

start:
mov ax, 0x0003
int 0x10

mov ax, 0x0000
mov al, 32
mov bx, 0x0000
mov es, bx
mov bx, 0x7E00
call disk_read

mov ax, SCR_ADDRESS_START
mov es, ax
mov ax, 0x0000

cmp byte [test], 0xFF
je extended_space_start

mov ax, 0x0000
mov dl, 0x0C
mov bx, error_0x0001_t
call scr_print_string

mov ax, SCR_WIDTH
mov dl, 0x0C
mov bx, error_0x0001_d
call scr_print_string

mov ax, SCR_WIDTH * 3
mov dl, 0x0C
mov bx, error_end5
call scr_print_string

call delay_1s

mov ax, SCR_WIDTH * 3 + 62
mov dl, 0x0C
mov bx, error_end4
call scr_print_string

call delay_1s

mov ax, SCR_WIDTH * 3 + 62
mov dl, 0x0C
mov bx, error_end3
call scr_print_string

call delay_1s

mov ax, SCR_WIDTH * 3 + 62
mov dl, 0x0C
mov bx, error_end2
call scr_print_string

call delay_1s

mov ax, SCR_WIDTH * 3 + 62
mov dl, 0x0C
mov bx, error_end1
call scr_print_string

call delay_1s

call power_shutdown

end:
    jmp $

%include "lib16/disk.asm"
%include "lib16/delay.asm"
%include "lib16/power.asm"

error_0x0001_t:
    db 'Error 0x0001:', 0
error_0x0001_d:
    db 'The system cannot read past the first sector.', 0
error_end5:
    db 'The computer will shut down in 5 seconds.', 0
error_end4:
    db '4 seconds.', 0
error_end3:
    db '3 seconds.', 0
error_end2:
    db '2 seconds.', 0
error_end1:
    db '1 second. ', 0

times 510-($-$$) db 0
db 0x55, 0xAA

extended_space_start:
    mov dl, SCR_WIDTH
    mov dh, SCR_HEIGHT
    call scr_cursor_set_pos
    ;call scr_cursor_disable

    mov byte [var_currentSelection], 0x00

    mov bx, SCR_WIDTH
    mov dl, 0xE0
    mov dh, 0x00
    call scr_draw_line

    mov bx, SCR_ADDRESS_END
    mov dl, 0xF0
    mov dh, 0x00
    call scr_draw_line

extended_space_loop_main:
    update_selection:
    .update_selection_01:
    mov ax, 0x0000
    mov dl, 0xE0
    mov bx, str__osNameExtended
    call scr_print_string

    cmp byte [var_currentSelection], 0x01
    jne .update_selection_02
    mov bx, str__osNameExtended_s
    call scr_print_string

    .update_selection_02:
    mov ax, SCR_WIDTH - 6
    mov dl, 0xCF
    mov bx, str__guiClose
    call scr_print_string

    cmp byte [var_currentSelection], 0x02
    jne .update_selection_03
    mov bx, str__guiClose_s
    call scr_print_string

    .update_selection_03:
    ; placeholder

    mov ax, 0
    mov al, 'A'
    call kb_waitForKey
    mov dl, al
    mov dh, 'X'
    mov ax, SCR_WIDTH * 2
    call scr_char_set

    mov ax, 0x0000
    mov dh, 0x00

    jmp extended_space_loop_main

extended_space_end:
    jmp $

scr_asm:
%include "lib16/screen3h.asm"
kb_asm:
%include "lib16/kb.asm"

var_start:
var_currentSelection: db 0x00
var_biggestSelection: db 0x02

str_start:
str__osNameExtended:
    db ' MagnesiumOS ', 0
str__osNameExtended_s:
    db '[MagnesiumOS]', 0
str__guiClose:
    db ' X ', 0
str__guiClose_s:
    db '[X]', 0

test: db 0xFF

times 512 * 32 - ($-$$) db 0