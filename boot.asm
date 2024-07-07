bits 16
org 0x7C00

SCR_ADDRESS_START   equ  0xB800
SCR_WIDTH           equ  0xA0
SCR_HEIGHT          equ  0x32
SCR_SIZE            equ  0x0FA0
SCR_ADDRESS_END     equ  0xD740

SCR13_ADDRESS_START   equ  0xA0000
SCR13_WIDTH           equ  0x0140
SCR13_HEIGHT          equ  0x00C8
SCR13_SIZE            equ  0xFA00
SCR13_ADDRESS_END     equ  0xAFA00
SCR13_WIDTH_MIDDLE    equ  0x00A0
SCR13_HEIGHT_MIDDLE   equ  0x7D00

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

call boot_scr_cursor_disable

mov ax, 0x0000
mov dl, 0x0F
mov bx, boot_loading1
call boot_scr_print_string

cmp byte [test], 0xFF                               ; KERNEL CHECK @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
jne boot_load_error

mov ax, 0x0002
mov dl, 0x0A
mov bx, boot_loading_done1
call boot_scr_print_string

call delay_1s

jmp extended_space_start

boot_load_error:
mov ax, 0x0002
mov dl, 0x0C
mov bx, boot_loading_err1
call boot_scr_print_string

call delay_1s

mov ax, 0x0000
mov bx, SCR_SIZE
mov dh, 0x00
mov dl, 0x1F
call boot_scr_draw_line

mov ax, 0x0000
mov dl, 0x1F
mov bx, boot_error_0x0001_t
call boot_scr_print_string

mov ax, SCR_WIDTH
mov dl, 0x1F
mov bx, boot_error_0x0001_d
call boot_scr_print_string

mov ax, SCR_WIDTH * 3
mov dl, 0x1F
mov bx, boot_error_help1
call boot_scr_print_string

end:
    jmp $

boot_scr_draw_line:
    cmp ax, bx
    je boot_global_ret
    call boot_scr_char_set
    add ax, 2
    jmp boot_scr_draw_line
boot_scr_print_string:
    mov dh, [bx]
    cmp dh, 0
    je boot_global_ret
    call boot_scr_char_set
    add ax, 2
    inc bx
    jmp boot_scr_print_string
boot_scr_char_set:
    mov di, ax
    mov [es:di], dh
    inc di
    mov [es:di], dl
    ret
boot_scr_cursor_disable:
    mov ax, 0x0000
    mov ah, 0x01
    mov ch, 0x3F
    int 0x10
    ret

boot_global_ret:
    ret

disk_asm:
%include "lib16/disk.asm"
delay_asm:
%include "lib16/delay.asm"

boot_error_0x0001_t:
    db "Error 0x0001:", 0
boot_error_0x0001_d:
    db "Cannot read past the first sector.", 0
boot_error_help1:
    db "Please read the user manual for more information.", 0
boot_loading1:
    db "[      ] Executing Kernel check", 0
boot_loading_done1:
    db "  OK  ", 0
boot_loading_err1:
    db "FAILED", 0

times 510-($-$$) db 0
db 0x55, 0xAA

;###############################################################################################################################

extended_space_start:
    call mos_show_logo
    call delay_2s

    call scr_init
    call scr_vga_disable_blinking
    call scr_cursor_disable
    mov byte [var_currentSelection], 0x00

    mov bx, SCR_WIDTH                           ; MENU BAR
    mov dl, 0xE0
    mov dh, 0x00
    call scr_draw_line

    mov bx, SCR_SIZE - SCR_WIDTH                ; DESKTOP
    mov dl, 0xF0
    mov dh, 0x00
    call scr_draw_line

    mov bx, SCR_SIZE                            ; FOOTER
    mov dl, 0xE0
    mov dh, 0x00
    call scr_draw_line
    
    mov ax, SCR_SIZE - SCR_WIDTH                ; FOOTER TEXT
    mov dl, 0xE0
    mov bx, str__osNameExtended
    call scr_print_string

extended_space_loop_main:
    update_selection:
    mov ax, 0x0000
    mov bx, SCR_WIDTH                           ; MENU BAR
    mov dl, 0xE0
    mov dh, 0x00
    call scr_draw_line

    mov bx, SCR_SIZE - SCR_WIDTH                ; DESKTOP
    mov dl, 0xF0
    mov dh, 0x00
    call scr_draw_line

    mov bx, SCR_SIZE                            ; FOOTER
    mov dl, 0xE0
    mov dh, 0x00
    call scr_draw_line
    .update_selection_00:                       ; guiMenuDebug
    mov ax, 0x0000
    mov dl, 0xE0
    mov bx, str__guiMenuDebug
    call scr_print_string

    cmp byte [var_currentSelection], 0x00
    jne .update_selection_01
    mov ax, 0x0000
    mov dl, 0x60
    mov bx, str__guiMenuDebug_s
    call scr_print_string

    .update_selection_01:                       ; guiMenuTestBIOS
    mov ax, 0x000E
    mov dl, 0xE0
    mov bx, str__guiMenuTestBIOS
    call scr_print_string

    cmp byte [var_currentSelection], 0x01
    jne .update_selection_02
    mov ax, 0x000E
    mov dl, 0x60
    mov bx, str__guiMenuTestBIOS_s
    call scr_print_string

    .update_selection_02:                       ; guiMenuTestBIOS
    mov ax, 0x0024
    mov dl, 0xE0
    mov bx, str__guiMenuPlayTestGame
    call scr_print_string

    cmp byte [var_currentSelection], 0x02
    jne .update_selection_03
    mov ax, 0x0024
    mov dl, 0x60
    mov bx, str__guiMenuPlayTestGame_s
    call scr_print_string
    
    .update_selection_03:                       ; guiClose
    mov ax, SCR_WIDTH - 6
    mov dl, 0xCF
    mov bx, str__guiClose
    call scr_print_string

    cmp byte [var_currentSelection], 0x03
    jne .update_selection_end
    mov ax, SCR_WIDTH - 6
    mov dl, 0x4F
    mov bx, str__guiClose_s
    call scr_print_string

    .update_selection_end:

    mov ax, 0
    call kb_waitForKey

    cmp ah, 0x4D                        ; ARROW_KEY_RIGHT
    je change_current_selection_1
    cmp ah, 0x4B                        ; ARROW_KEY_LEFT
    je change_current_selection_0
    cmp ah, 0x1C                        ; ENTER
    je execute_current_selection
    jmp extended_space_loop_main

change_current_selection_1:
    mov al, [var_biggestSelection]
    cmp [var_currentSelection], al
    je change_current_selection_reset
    inc byte [var_currentSelection]
    jmp extended_space_loop_main
change_current_selection_0:
    cmp byte [var_currentSelection], 0x00
    je change_current_selection_max
    dec byte [var_currentSelection]
    jmp extended_space_loop_main
change_current_selection_reset:
    mov byte [var_currentSelection], 0x00
    jmp extended_space_loop_main
change_current_selection_max:
    mov al, [var_biggestSelection]
    mov byte [var_currentSelection], al
    jmp extended_space_loop_main

execute_current_selection:
    cmp byte [var_currentSelection], 0x00
    je execute_selection_00
    cmp byte [var_currentSelection], 0x01
    je execute_selection_01
    cmp byte [var_currentSelection], 0x02
    je execute_selection_02
    cmp byte [var_currentSelection], 0x03
    je execute_selection_03
    jmp extended_space_loop_main

execute_selection_00:
    jmp extended_space_loop_main

execute_selection_01:
    mov word [error_t], error_0x0002_t
    mov word [error_d], error_0x0002_d
    call start_extended_bsod
    jmp $

execute_selection_02:
    jmp extended_space_loop_main

execute_selection_03:
    jmp system_shutdown

extended_space_end:
    jmp $

system_shutdown:
    call power_shutdown
    
    call scr13_init

    mov ax, 0x0000
    mov bx, SCR13_SIZE
    mov dl, 0x12
    call scr13_draw_line

    mov ax, 0x0000
    mov dl, 0x00
    .system_shutdown_checkerboard_loop:
        call scr13_pixel_set
        add ax, 3
        cmp ax, SCR13_SIZE + 1
        jne .system_shutdown_checkerboard_loop
    
    mov ax, SCR13_HEIGHT_MIDDLE + (SCR13_WIDTH * 16) + SCR13_WIDTH_MIDDLE - 8
    mov dl, 0x0C
    mov bx, 0x5C
    call scr13_print_char_partof_str
    mov dl, 0x0C
    mov bx, 0x5D
    call scr13_print_char_partof_str
    mov dl, 0x0C
    mov bx, 0x5E
    call scr13_print_char_partof_str
    mov dl, 0x0C
    mov bx, 0x5F
    call scr13_print_char_partof_str
    mov ax, SCR13_HEIGHT_MIDDLE + (SCR13_WIDTH * 24) + SCR13_WIDTH_MIDDLE - 8
    mov dl, 0x0C
    mov bx, 0x60
    call scr13_print_char_partof_str
    mov dl, 0x0C
    mov bx, 0x61
    call scr13_print_char_partof_str
    mov dl, 0x0C
    mov bx, 0x62
    call scr13_print_char_partof_str
    mov dl, 0x0C
    mov bx, 0x63
    call scr13_print_char_partof_str
    
    mov ax, SCR13_HEIGHT_MIDDLE - (SCR13_WIDTH * 4) + SCR13_WIDTH_MIDDLE - (40 * 2)
    mov dl, 0x0E
    mov bx, 'I'
    call scr13_print_char_partof_str
    mov bx, 'T'
    call scr13_print_char_partof_str
    add ax, 4
    mov bx, 'I'
    call scr13_print_char_partof_str
    mov bx, 'S'
    call scr13_print_char_partof_str
    add ax, 4
    mov bx, 'N'
    call scr13_print_char_partof_str
    mov bx, 'O'
    call scr13_print_char_partof_str
    mov bx, 'W'
    call scr13_print_char_partof_str
    add ax, 4
    mov bx, 'S'
    call scr13_print_char_partof_str
    mov bx, 'A'
    call scr13_print_char_partof_str
    mov bx, 'F'
    call scr13_print_char_partof_str
    mov bx, 'E'
    call scr13_print_char_partof_str
    add ax, 4
    mov bx, 'T'
    call scr13_print_char_partof_str
    mov bx, 'O'
    call scr13_print_char_partof_str
    add ax, 4
    mov bx, 'T'
    call scr13_print_char_partof_str
    mov bx, 'U'
    call scr13_print_char_partof_str
    mov bx, 'R'
    call scr13_print_char_partof_str
    mov bx, 'N'
    call scr13_print_char_partof_str
    add ax, 4
    mov bx, 'O'
    call scr13_print_char_partof_str
    mov bx, 'F'
    call scr13_print_char_partof_str
    call scr13_print_char_partof_str
    add ax, 4
    mov bx, 'Y'
    call scr13_print_char_partof_str
    mov bx, 'O'
    call scr13_print_char_partof_str
    mov bx, 'U'
    call scr13_print_char_partof_str
    mov bx, 'R'
    call scr13_print_char_partof_str
    add ax, 4
    mov bx, 'C'
    call scr13_print_char_partof_str
    mov bx, 'O'
    call scr13_print_char_partof_str
    mov bx, 'M'
    call scr13_print_char_partof_str
    mov bx, 'P'
    call scr13_print_char_partof_str
    mov bx, 'U'
    call scr13_print_char_partof_str
    mov bx, 'T'
    call scr13_print_char_partof_str
    mov bx, 'E'
    call scr13_print_char_partof_str
    mov bx, 'R'
    call scr13_print_char_partof_str
    jmp $

mos_show_logo:
    call scr13_init
    mov ax, 0x0000
    mov bx, SCR13_SIZE
    mov dl, 0x12
    call scr13_draw_line

    mov ax, SCR13_HEIGHT_MIDDLE - (SCR13_WIDTH * 16) + SCR13_WIDTH_MIDDLE - (11 * 8)
    mov dl, 0x1E
    mov bx, 'M'
    call scr13_print_char_partof_str_x4
    mov bx, 'A'
    call scr13_print_char_partof_str_x4
    mov bx, 'G'
    call scr13_print_char_partof_str_x4
    mov bx, 'N'
    call scr13_print_char_partof_str_x4
    mov bx, 'E'
    call scr13_print_char_partof_str_x4
    mov bx, 'S'
    call scr13_print_char_partof_str_x4
    mov bx, 'I'
    call scr13_print_char_partof_str_x4
    mov bx, 'U'
    call scr13_print_char_partof_str_x4
    mov bx, 'M'
    call scr13_print_char_partof_str_x4
    mov dl, 0x19
    mov bx, 'O'
    call scr13_print_char_partof_str_x4
    mov bx, 'S'
    call scr13_print_char_partof_str_x4

    mov ax, SCR13_WIDTH * 191 + 1
    mov dl, 0x15
    mov bx, 'L'
    call scr13_print_char_partof_str
    mov bx, 'O'
    call scr13_print_char_partof_str
    mov bx, 'A'
    call scr13_print_char_partof_str
    mov bx, 'D'
    call scr13_print_char_partof_str
    mov bx, 'I'
    call scr13_print_char_partof_str
    mov bx, 'N'
    call scr13_print_char_partof_str
    mov bx, 'G'
    call scr13_print_char_partof_str
    mov bx, '.'
    call scr13_print_char_partof_str
    call scr13_print_char_partof_str
    call scr13_print_char_partof_str

    ret

var_start:
var_currentSelection: db 0x00
var_biggestSelection: db 0x03

str_start:
str__osNameExtended:
    db ' MagnesiumOS Version 0.01 ', 0
str__osNameExtended_s:
    db '[MagnesiumOS Version 0.01]', 0
str__guiClose:
    db ' X ', 0
str__guiClose_s:
    db '[X]', 0
str__guiMenuDebug:
    db ' Debug ', 0
str__guiMenuDebug_s:
    db '[Debug]', 0
str__guiMenuTestBIOS:
    db ' Test BIOS ', 0
str__guiMenuTestBIOS_s:
    db '[Test BIOS]', 0
str__guiMenuPlayTestGame:
    db ' Play test game ', 0
str__guiMenuPlayTestGame_s:
    db '[Play test game]', 0
str__guiMenuDebug__invokeBSOD:
    db ' Invoke BSOD ', 0
str__guiMenuDebug__invokeBSOD_s:
    db '[Invoke BSOD]', 0
str__guiBack:
    db ' Back ', 0
str__guiBack_s:
    db '[Back]', 0

scr3_asm:
%include "lib16/screen3h.asm"
scr13_asm:
%include "lib16/screen13h.asm"
power_asm:
%include "lib16/power.asm"
error_asm:
%include "lib16/error.asm"
kb_asm:
%include "lib16/kb.asm"
audio_asm:
%include "lib16/audio.asm"

test: db 0xFF

error_t: dw 0x0000
error_d: dw 0x0000
error_help1: db "If this is the first time you've seen this error screen, restart your computer.", 0
error_help2: db "If this screen appears again, follow these steps:", 0
error_help3: db "If this is a new installation, ask your hardware or software manufacturer for", 0
error_help4: db "any MagnesiumOS updates you might need.", 0
error_help5: db "If problems continue, disable BIOS memory options such as caching or shadowing.", 0

error_start:
error_0x0002_t: db "Error 0x0002:", 0
error_0x0002_d: db "The user manually invoked this error message.", 0


test_game_init:
call scr13_init


times 512 * 32 - ($-$$) db 0