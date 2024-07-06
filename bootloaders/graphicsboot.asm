bits 16
org 0x7E00

SCR_ADDRESS_START   equ  0xA000
SCR_WIDTH           equ  0x0140
SCR_HEIGHT          equ  0x00C8
SCR_ADDRESS_END     equ 0x19A00

start:
mov ax, 0x07C0
mov ss, ax
mov sp, 0x0000

push cs
pop ds

mov al, 32
mov bx, 0x0000
mov es, bx
mov bx, 0x7E00
call disk_read

mov ax, SCR_ADDRESS_START
mov es, ax
mov ax, 0x0000

jmp extended_space_start

end:
    jmp $

disk_asm:
%include "lib16/disk.asm"

times 510-($-$$) db 0
db 0x55, 0xAA

extended_space_start:
    mov ax, 0x0013              ; Graphics mode 13
    int 0x10                    ; BIOS Interrupt for changing graphics

    mov ax, 0x0000
    mov bx, SCR_WIDTH * 10      ; MENU BAR
    mov dl, 0x0E
    call scr_draw_line
    mov bx, SCR_WIDTH * 190     ; DESKTOP
    mov dl, 0x0F
    call scr_draw_line
    mov bx, SCR_WIDTH * 200     ; INFO
    mov dl, 0x0E
    call scr_draw_line

    mov ax, 0x0000
    mov dl, 0x00
    mov bx, 'A'
    call scr_print_char_partof_str

extended_space_end:
    jmp $

scr_asm:
%include "lib16/screen13h.asm"

test: db 0xFF

times 512 * 32 - ($-$$) db 0