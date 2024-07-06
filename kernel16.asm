extended_space_start:
    call scr_vga_disable_blinking
    call scr_cursor_disable

    mov byte [var_currentSelection], 0x00

    mov bx, SCR_WIDTH                           ; MENU BAR
    mov dl, 0x60
    mov dh, 0x00
    call scr_draw_line

    mov bx, SCR_SIZE - SCR_WIDTH                ; DESKTOP
    mov dl, 0x70
    mov dh, 0x00
    call scr_draw_line

    mov bx, SCR_SIZE                            ; FOOTER
    mov dl, 0x60
    mov dh, 0x00
    call scr_draw_line
    
    mov ax, SCR_SIZE - SCR_WIDTH                ; FOOTER TEXT
    mov dl, 0x60
    mov bx, str__osNameExtended
    call scr_print_string

extended_space_loop_main:
    update_selection:
    .update_selection_00:
    mov ax, 0x0000
    mov dl, 0x60
    mov bx, str__guiMenuSystem
    call scr_print_string

    cmp byte [var_currentSelection], 0x00
    jne .update_selection_01
    mov ax, 0x0000
    mov dl, 0xE0
    mov bx, str__guiMenuSystem_s
    call scr_print_string

    .update_selection_01:
    mov ax, SCR_WIDTH - 6
    mov dl, 0x4F
    mov bx, str__guiClose
    call scr_print_string

    cmp byte [var_currentSelection], 0x01
    jne .update_selection_02
    mov ax, SCR_WIDTH - 6
    mov dl, 0xCF
    mov bx, str__guiClose_s
    call scr_print_string

    .update_selection_02:
    ; placeholder

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
    inc byte [var_currentSelection]
    mov al, [var_biggestSelection]
    cmp [var_currentSelection], al
    je change_current_selection_reset
    jmp extended_space_loop_main
change_current_selection_0:
    dec byte [var_currentSelection]
    cmp byte [var_currentSelection], 0xFF
    je change_current_selection_max
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
    jmp extended_space_loop_main

execute_selection_00:
    mov word [error_t], error_0x0002_t
    mov word [error_d], error_0x0002_d
    call start_extended_bsod
    jmp $

execute_selection_01:
    call power_shutdown
    jmp extended_space_loop_main

extended_space_end:
    jmp $

kb_asm:
%include "lib16/kb.asm"



var_start:
var_currentSelection: db 0x00
var_biggestSelection: db 0x02

str_start:
str__osNameExtended:
    db ' MagnesiumOS Version 0.01 - Real Mode', 0
str__guiClose:
    db ' X ', 0
str__guiClose_s:
    db '[X]', 0
str__guiMenuSystem:
    db ' Invoke BSOD ', 0
str__guiMenuSystem_s:
    db '[Invoke BSOD]', 0

scr_asm:
%include "lib16/screen3h.asm"
power_asm:
%include "lib16/power.asm"
error_asm:
%include "lib16/error.asm"

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

times 512 * 32 - ($-$$) db 0