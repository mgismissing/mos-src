bits 16
org 0x7C00

SCR_ADDRESS_START   equ  0xB800
SCR_WIDTH           equ  0xA0
SCR_HEIGHT          equ  0x32
SCR_SIZE            equ  0x0FA0
SCR_ADDRESS_END     equ  0xD740
SCR_HEIGHT_MIDDLE   equ  0x07D0

SCR13_ADDRESS_START   equ  0xA0000
SCR13_WIDTH           equ  0x0140
SCR13_HEIGHT          equ  0x00C8
SCR13_SIZE            equ  0xFA00
SCR13_ADDRESS_END     equ  0xAFA00
SCR13_WIDTH_MIDDLE    equ  0x00A0
SCR13_HEIGHT_MIDDLE   equ  0x7D00

absolute_start:
jmp short start

%include "lib16/bpb.asm"

start:
mov ax, 0x0003
int 0x10

mov ax, 0x0000
mov al, 32
mov bx, 0x0000
mov es, bx
mov bx, 0x7E00
call disk_read

call boot_scr_cursor_disable

mov ax, SCR_ADDRESS_START
mov es, ax
mov ax, 0x0000

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

mov ax, SCR_WIDTH * 2
mov dl, 0x0F
mov bx, boot_load_wait
call boot_scr_print_string

call kb_waitForKey
jmp cmd_start

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
kb_asm:
%include "lib16/kb.asm"

boot_error_0x0001_t:
    db "Error 0x0001:", 0
boot_error_0x0001_d:
    db "Cannot read past the first sector.", 0
boot_loading1:
    db "[      ] Executing Kernel check", 0
boot_loading_done1:
    db "  OK  ", 0
boot_loading_err1:
    db "FAILED", 0
boot_load_wait:
    db "Press any key to continue...", 0

times 510-($-$$) db 0x00
db 0x55, 0xAA

;###############################################################################################################################

%include "macros.asm"

%include "lib16/gdt.asm"

extended_space_load:
    mov byte [var_currentSelection], 0x00
    call mos_show_logo
    call delay_1s
    jmp win_start

%include "window.asm"

system_shutdown_screen:
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
    mov bx, img_shutdown_16
    call scr13_draw_img_16x16
    
    mov ax, SCR13_HEIGHT_MIDDLE - (SCR13_WIDTH * 4) + SCR13_WIDTH_MIDDLE - (40 * 2)
    mov dl, 0x0E
    mov bx, str_shutdown
    call scr13_print_string
    jmp $

mos_show_logo:
    call scr13_init
    mov ax, 0x0000
    mov bx, SCR13_SIZE
    mov dl, 0x12
    call scr13_draw_line

    mov ax, SCR13_HEIGHT_MIDDLE - (SCR13_WIDTH * 16) + SCR13_WIDTH_MIDDLE - (11 * 8)
    mov dl, 0x1E
    mov bx, .str_magnesium
    call scr13_print_string_x4
    mov dl, 0x19
    mov bx, .str_os
    call scr13_print_string_x4

    mov ax, SCR13_WIDTH * 191 + 1
    mov dl, 0x15
    mov bx, str_loading
    call scr13_print_string
    ret

    .str_magnesium: db 'MAGNESIUM', 0
    .str_os: db 'OS', 0

var_start:
var_currentSelection: db 0x00
var_biggestSelection: db 0x03

str_start:
str__osNameExtended:
    db ' MagnesiumOS ', 0
str__osNameExtended_s:
    db '[MagnesiumOS]', 0
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
audio_asm:
%include "lib16/audio.asm"
cmd_asm:
%include "cmd.asm"

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

sm_str_start:
sm_str_warning1: db "WARNING", 0
sm_str_warning2: db "Booting MagnesiumOS in Safe Mode can lead to instability and loss of data.", 0
sm_str_warning3: db "Boot normally [Any key]", 0
sm_str_warning4: db "Continue      [Enter  ]", 0
sm_str_warning5: db "This is the final warning. Really continue?", 0
sm_str_shutdown: db "It is now safe to turn off your computer", 0

str_shutdown: db "IT IS NOW SAFE TO TURN OFF YOUR COMPUTER", 0
str_loading: db "LOADING...", 0

img_shutdown_16: ; 0xFF, 0x0C
    db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0x0C, 0x0C, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0x0C, 0xFF, 0x0C, 0x0C, 0xFF, 0x0C, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF
    db 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF
    db 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF
    db 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0C, 0x0C, 0x0C, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF

%include "lib16/pm.asm"
%include "pm/main.asm"

global_end:
times 512 * 32 - ($-$$) db 0
global_absolute_end:

; THE TOTAL FLOPPY SIZE IS 1.44 MB OR 1474560 BYTES (2880 SECTORS)