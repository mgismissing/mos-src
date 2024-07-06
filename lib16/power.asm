power_shutdown:                     ; power_shutdown() => None
    mov ax, 0x5301
    mov bx, 0x0000
    int 0x15

    mov ax, 0x530E
    mov bx, 0x0000
    mov cx, 0x0102
    int 0x15

    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15

    ret