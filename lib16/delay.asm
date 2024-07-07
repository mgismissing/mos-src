delay_2s:                   ; delay_2s() => None
    mov ax, 0x0000
    mov ah, 0x86
    mov cx, 0x001E
    mov dx, 0x8480
    int 0x15
    ret
delay_1s:                   ; delay_1s() => None
    mov ax, 0x0000
    mov ah, 0x86
    mov cx, 0x000F
    mov dx, 0x4240
    int 0x15
    ret
delay_500ms:                ; delay_500ms() => None
    mov ax, 0x0000
    mov ah, 0x86
    mov cx, 0x0007
    mov dx, 0xA120
    int 0x15
    ret
delay_200ms:                ; delay_200ms() => None
    mov ax, 0x0000
    mov ah, 0x86
    mov cx, 0x0003
    mov dx, 0x0D40
    int 0x15
    ret