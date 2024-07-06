disk_read:              ; disk_read(al > Number of sectors, dl > Drive number, es:bx > Address)
    push ax             ; Push the number of sectors for checking later
    mov ah, 0x02        ; Disk read operation
    mov ch, 0x00        ; Cylinder
    mov dh, 0x00        ; Head
    mov cl, 0x02        ; Sector (0x01 = BOOT)
;   mov dl, 0x00        ; Drive number (may be set by the BIOS) 0x00: 1st Floppy, 0x01: 2nd Floppy, 0x80: 1st Hard Disk Drive, 0x81: 2nd Hard Disk Drive

    int 0x13            ; Call the BIOS
    jc .disk_error      ; If any error happens the Carry is set to 1
    pop bx
    cmp al, bl
    jne .sector_error

    ret

.disk_error:
.sector_error:
    jmp $