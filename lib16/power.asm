power_shutdown:                     ; power_shutdown() => None
    ; Initialize APM
    mov ax, 0x5301          ; APM installation check
    xor bx, bx              ; Device 0 (System BIOS)
    int 0x15                ; Call APM BIOS

    ; If APM is supported, proceed with shutdown
    cmp ax, 0x5341          ; Check for "APM" signature
    jne .no_apm             ; Jump if APM is not supported

    ; Connect to APM
    mov ax, 0x5303          ; APM connect
    xor bx, bx              ; Device 0 (System BIOS)
    int 0x15                ; Call APM BIOS

    ; Set power state to off
    mov ax, 0x5307          ; APM set power state
    xor bx, bx              ; Device 0 (System BIOS)
    mov cx, 0x0003          ; Power off state
    int 0x15                ; Call APM BIOS

    .no_apm:
    ret