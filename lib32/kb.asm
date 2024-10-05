PM_KB_PORT_DATA     equ 0x60
PM_KB_PORT_STATUS   equ 0x64

PM_KB_STATUS_ACK    equ 0xFA
PM_KB_STATUS_RESEND equ 0xFE

PM_KB_CMD_SET_LEDS  equ 0xED
PM_KB_CMD_ENABLE    equ 0xF4
PM_KB_CMD_DISABLE   equ 0xF5

pm_kb_irq_handler:
    pusha
    cld
    call pm_kb_handler
    popa
    iret

pm_kb_handler:
    ret

pm_kb_waitForKey:      ; kb_waitForKey() => al > Char, ah > Scancode
    mov ax, 0          ; BIOS keyboard function: read keystroke
    ;int 0x16           ; BIOS keyboard interrupt
    ret

pm_kb_set_leds:        ; pm_kb_set_lets(al[0] > ScrollLock, al[1] > NumberLock, al[2] > CapsLock) => None
    push ax
    mov al, PM_KB_CMD_SET_LEDS
    out PM_KB_PORT_STATUS, al
    pop ax
    push ax
    out PM_KB_PORT_STATUS, al
    in al, PM_KB_PORT_STATUS
    cmp al, PM_KB_STATUS_RESEND
    pop ax
    jne pm_kb_global_ret
    jmp pm_kb_set_leds

pm_kb_enable:          ; pm_kb_enable() => None
    mov al, PM_KB_CMD_ENABLE
    out PM_KB_PORT_STATUS, al
    in al, PM_KB_PORT_STATUS
    cmp al, PM_KB_STATUS_RESEND
    jne pm_kb_global_ret
    jmp pm_kb_enable

pm_kb_disable:         ; pm_kb_disable() => None
    mov al, PM_KB_CMD_DISABLE
    out PM_KB_PORT_STATUS, al
    in al, PM_KB_PORT_STATUS
    cmp al, PM_KB_STATUS_RESEND
    jne pm_kb_global_ret
    jmp pm_kb_disable

pm_kb_global_ret:
    ret