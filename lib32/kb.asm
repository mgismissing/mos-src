pm_kb_waitForKey:      ; kb_waitForKey() => al > Char, ah > Scancode
    mov ax, 0          ; BIOS keyboard function: read keystroke
    ;int 0x16           ; BIOS keyboard interrupt
    ret